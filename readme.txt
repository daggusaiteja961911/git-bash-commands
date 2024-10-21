package com.walmart.international.wallet.payment.app.controller.impl.billpay;

import com.walmart.international.digiwallet.service.basic.ng.exception.ApplicationException;
import com.walmart.international.wallet.payment.app.auth.WPSAuthValidator;
import com.walmart.international.wallet.payment.app.service.BillPaymentService;
import com.walmart.international.wallet.payment.dto.request.billpay.*;
import com.walmart.international.wallet.payment.dto.response.billpay.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.util.MultiValueMap;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(BillPaymentControllerImpl.class)
public class BillPaymentControllerImplTest {

    @MockBean
    private BillPaymentService billPaymentService;

    @MockBean
    private WPSAuthValidator wpsAuthValidator;

    @Captor
    private ArgumentCaptor<MultiValueMap<String, String>> headersCaptor;

    @Autowired
    private MockMvc mockMvc;

    private FetchBillPayPaymentInstrumentsRequest fetchBillPayPaymentInstrumentsRequest;
    private PayBillInitRequest payBillInitRequest;
    private ReconcilePendingBillPayTxnRequest reconcilePendingBillPayTxnRequest;
    private CancelPayBillInitRequest cancelPayBillInitRequest;
    private ValidatePayBillInitRequest validatePayBillInitRequest;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.initMocks(this);

        fetchBillPayPaymentInstrumentsRequest = new FetchBillPayPaymentInstrumentsRequest();
        fetchBillPayPaymentInstrumentsRequest.setCustomerAccountId(123L);

        payBillInitRequest = new PayBillInitRequest();
        payBillInitRequest.setCustomerAccountId(123L);

        reconcilePendingBillPayTxnRequest = new ReconcilePendingBillPayTxnRequest();
        reconcilePendingBillPayTxnRequest.setCustomerAccountId(123L);

        cancelPayBillInitRequest = new CancelPayBillInitRequest();
        cancelPayBillInitRequest.setCustomerAccountId(123L);

        validatePayBillInitRequest = new ValidatePayBillInitRequest();
        validatePayBillInitRequest.setCustomerAccountId(123L);
    }

    @Test
    public void testFetchBillPayPaymentInstruments() throws Exception {
        FetchBillPayPaymentInstrumentsResponse expectedResponse = new FetchBillPayPaymentInstrumentsResponse();

        given(billPaymentService.fetchBillPayPaymentInstruments(any(), any()))
                .willReturn(expectedResponse);

        mockMvc.perform(MockMvcRequestBuilders.get("/bill-payment/fetch-instruments")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());

        verifyWPSAuthValidatorCalledWith(fetchBillPayPaymentInstrumentsRequest.getCustomerAccountId().toString());
    }

    @Test
    public void testFetchBillPayPaymentInstrumentsWithPreselection() throws Exception {
        FetchBillPayPaymentInstrumentsWithPreselectionResponse expectedResponse = new FetchBillPayPaymentInstrumentsWithPreselectionResponse();

        given(billPaymentService.fetchBillPayPaymentInstrumentsWithPreselection(any(), any()))
                .willReturn(expectedResponse);

        mockMvc.perform(MockMvcRequestBuilders.get("/bill-payment/fetch-instruments-with-preselection")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());

        verifyWPSAuthValidatorCalledWith(fetchBillPayPaymentInstrumentsRequest.getCustomerAccountId().toString());
    }

    @Test
    public void testPayBillInit() throws Exception {
        PayBillInitResponse expectedResponse = new PayBillInitResponse();

        given(billPaymentService.payBillInit(any(), any()))
                .willReturn(expectedResponse);

        mockMvc.perform(MockMvcRequestBuilders.post("/bill-payment/pay-bill-init")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());

        verifyWPSAuthValidatorCalledWith(payBillInitRequest.getCustomerAccountId().toString());
    }

    @Test
    public void testReconcilePendingBillPayTxn() throws Exception {
        ReconcilePendingBillPayTxnResponse expectedResponse = new ReconcilePendingBillPayTxnResponse();

        given(billPaymentService.reconcilePendingBillPayTxn(any(), any()))
                .willReturn(expectedResponse);

        mockMvc.perform(MockMvcRequestBuilders.post("/bill-payment/reconcile-pending-txn")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());
    }

    @Test
    public void testCancelPayBillInit() throws Exception {
        CancelPayBillInitResponse expectedResponse = new CancelPayBillInitResponse();

        given(billPaymentService.cancelPayBillInit(any(), any()))
                .willReturn(expectedResponse);

        mockMvc.perform(MockMvcRequestBuilders.post("/bill-payment/cancel-pay-bill-init")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());

        verifyWPSAuthValidatorCalledWith(cancelPayBillInitRequest.getCustomerAccountId().toString());
    }

    @Test
    public void testValidatePayBillInit() throws Exception {
        ValidatePayBillInitResponse expectedResponse = new ValidatePayBillInitResponse();

        given(billPaymentService.validatePayBillInit(any(), any()))
                .willReturn(expectedResponse);

        mockMvc.perform(MockMvcRequestBuilders.post("/bill-payment/validate-pay-bill-init")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());

        verifyWPSAuthValidatorCalledWith(validatePayBillInitRequest.getCustomerAccountId().toString());
    }

    private void verifyWPSAuthValidatorCalledWith(String customerAccountId) {
        ArgumentCaptor<String> customerIdCaptor = ArgumentCaptor.forClass(String.class);
        ArgumentCaptor<String> headerKeyCaptor = ArgumentCaptor.forClass(String.class);

        org.mockito.Mockito.verify(wpsAuthValidator, org.mockito.Mockito.times(1))
                .validateHeaderUserId(eq(customerIdCaptor.capture()), eq(headerKeyCaptor.capture()));

        assertEquals(customerAccountId, customerIdCaptor.getValue());
        assertEquals("userId", headerKeyCaptor.getValue());
    }
}
.....................................
package com.walmart.international.wallet.payment.app.controller.impl.billpay;

import com.walmart.international.digiwallet.service.basic.ng.exception.ApplicationException;
import com.walmart.international.wallet.payment.app.auth.WPSAuthValidator;
import com.walmart.international.wallet.payment.app.service.BillPaymentService;
import com.walmart.international.wallet.payment.dto.request.billpay.*;
import com.walmart.international.wallet.payment.dto.response.billpay.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.util.MultiValueMap;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(BillPaymentControllerImpl.class)
public class BillPaymentControllerImplTest {

    @MockBean
    private BillPaymentService billPaymentService;

    @MockBean
    private WPSAuthValidator wpsAuthValidator;

    @Captor
    private ArgumentCaptor<MultiValueMap<String, String>> headersCaptor;

    @Autowired
    private MockMvc mockMvc;

    private FetchBillPayPaymentInstrumentsRequest fetchBillPayPaymentInstrumentsRequest;
    private PayBillInitRequest payBillInitRequest;
    private ReconcilePendingBillPayTxnRequest reconcilePendingBillPayTxnRequest;
    private CancelPayBillInitRequest cancelPayBillInitRequest;
    private ValidatePayBillInitRequest validatePayBillInitRequest;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.initMocks(this);

        fetchBillPayPaymentInstrumentsRequest = new FetchBillPayPaymentInstrumentsRequest();
        fetchBillPayPaymentInstrumentsRequest.setCustomerAccountId(123L);

        payBillInitRequest = new PayBillInitRequest();
        payBillInitRequest.setCustomerAccountId(123L);

        reconcilePendingBillPayTxnRequest = new ReconcilePendingBillPayTxnRequest();
        reconcilePendingBillPayTxnRequest.setCustomerAccountId(123L);

        cancelPayBillInitRequest = new CancelPayBillInitRequest();
        cancelPayBillInitRequest.setCustomerAccountId(123L);

        validatePayBillInitRequest = new ValidatePayBillInitRequest();
        validatePayBillInitRequest.setCustomerAccountId(123L);
    }

    @Test
    public void testFetchBillPayPaymentInstruments_success() throws Exception {
        FetchBillPayPaymentInstrumentsResponse expectedResponse = new FetchBillPayPaymentInstrumentsResponse();

        given(billPaymentService.fetchBillPayPaymentInstruments(any(), any()))
                .willReturn(expectedResponse);

        mockMvc.perform(MockMvcRequestBuilders.get("/bill-payment/fetch-instruments")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());

        verifyWPSAuthValidatorCalledWith(fetchBillPayPaymentInstrumentsRequest.getCustomerAccountId().toString());
    }

    @Test
    public void testFetchBillPayPaymentInstruments_withException() throws Exception {
        given(billPaymentService.fetchBillPayPaymentInstruments(any(), any()))
                .willThrow(new ApplicationException("Error fetching payment instruments"));

        mockMvc.perform(MockMvcRequestBuilders.get("/bill-payment/fetch-instruments")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isInternalServerError());

        verifyWPSAuthValidatorCalledWith(fetchBillPayPaymentInstrumentsRequest.getCustomerAccountId().toString());
    }

    // Add similar test cases for other methods (fetchBillPayPaymentInstrumentsWithPreselection, payBillInit, etc.)

    private void verifyWPSAuthValidatorCalledWith(String customerAccountId) {
        ArgumentCaptor<String> customerIdCaptor = ArgumentCaptor.forClass(String.class);
        ArgumentCaptor<String> headerKeyCaptor = ArgumentCaptor.forClass(String.class);

        org.mockito.Mockito.verify(wpsAuthValidator, org.mockito.Mockito.times(1))
                .validateHeaderUserId(eq(customerIdCaptor.capture()), eq(headerKeyCaptor.capture()));

        assertEquals(customerAccountId, customerIdCaptor.getValue());
        assertEquals("userId", headerKeyCaptor.getValue());
    }
}
.................................................................
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class BillerCoreServiceImplTest {

    @InjectMocks
    private BillerCoreServiceImpl billerCoreService;

    @Mock
    private WmClient wmClient;

    @Mock
    private BillerCategoryVersionMappingRepository billerCategoryVersionMappingRepository;

    @Mock
    private BillerRepository billerRepository;

    @Mock
    private BillerSearchRepository billerSearchRepository;

    private BillerMapper billerMapper = BillerMapper.INSTANCE;

    private BillerDO billerDO;

    @BeforeEach
    public void setUp() {
        billerDO = new BillerDO();
        billerDO.setBillerId(UUID.randomUUID());
        billerDO.setProcessorBillerId("test_processor_biller_id");
        billerDO.setBillerName("Test Biller");
        billerDO.setEnabled(true);
        billerDO.setBillerCategoryVersion(1);
        billerDO.setBillerBehaviourCode("BBC1");

        when(billerRepository.getBillerInfoByBillerId(any(UUID.class), anyBoolean()))
                .thenReturn(billerDO);

        when(billerRepository.getBillerInfoByProcessorBillerId(any(String.class), anyBoolean()))
                .thenReturn(billerDO);

        when(billerCategoryVersionMappingRepository.getBillerCategoriesWithBillers(anyList()))
                .thenReturn(new ArrayList<>());

        when(billerSearchRepository.getBillerIncorrectSearchKeywords(anyList()))
                .thenReturn(new ArrayList<>());
    }

    @Test
    public void fetchBillerDataByBillerId_shouldReturnBiller() {
        UUID billerId = billerDO.getBillerId();
        Biller biller = billerCoreService.fetchBillerDataByBillerId(billerId);
        assertNotNull(biller);
        assertEquals(billerId, biller.getBillerId());
        assertEquals(billerDO.getProcessorBillerId(), biller.getProcessorBillerId());
        assertEquals(billerDO.getBillerName(), biller.getBillerName());
        assertEquals(billerDO.isEnabled(), biller.isEnabled());
        assertEquals(billerDO.getBillerCategoryVersion(), biller.getBillerCategoryVersion());
        assertEquals(billerDO.getBillerBehaviourCode(), biller.getBillerBehaviourCode());
    }

    @Test
    public void fetchBillerDataByProcessorBillerId_shouldReturnBiller() {
        String processorBillerId = billerDO.getProcessorBillerId();
        Biller biller = billerCoreService.fetchBillerDataByProcessorBillerId(processorBillerId);
        assertNotNull(biller);
        assertEquals(billerDO.getBillerId(), biller.getBillerId());
        assertEquals(processorBillerId, biller.getProcessorBillerId());
        assertEquals(billerDO.getBillerName(), biller.getBillerName());
        assertEquals(billerDO.isEnabled(), biller.isEnabled());
        assertEquals(billerDO.getBillerCategoryVersion(), biller.getBillerCategoryVersion());
        assertEquals(billerDO.getBillerBehaviourCode(), biller.getBillerBehaviourCode());
    }

    @Test
    public void fetchBillerDataLastUpdatedAt_shouldReturnDate() {
        Date lastUpdatedAt = billerCoreService.fetchBillerDataLastUpdatedAt(billerDO.getBillerId(), billerDO.getProcessorBillerId());
        assertNotNull(lastUpdatedAt);
    }

    @Test
    public void fetchBillerDataLastUpdatedAtMap_shouldReturnMap() {
        List<UUID> billerIds = List.of(billerDO.getBillerId());
        List<String> processorBillerIds = List.of(billerDO.getProcessorBillerId());
        Map<String, Object> billerDataLastUpdateAtMap = billerCoreService.fetchBillerDataLastUpdatedAtMap(billerIds, processorBillerIds);
        assertNotNull(billerDataLastUpdateAtMap);
        assertTrue(billerDataLastUpdateAtMap.containsKey(billerDO.getBillerId().toString() + WPSConstants.Biller.SUFFIX_BILLER_DATA_UPDATED_AT));
        assertTrue(billerDataLastUpdateAtMap.containsKey(billerDO.getProcessorBillerId() + WPSConstants.Biller.SUFFIX_BILLER_DATA_UPDATED_AT));
    }

    // Add more test cases as per your requirements
}
...............
package com.walmart.international.wallet.payment.app.controller.impl.billpay;

import com.walmart.international.digiwallet.service.basic.ng.exception.ApplicationException;
import com.walmart.international.wallet.payment.app.service.BillPaymentService;
import com.walmart.international.wallet.payment.app.auth.WPSAuthValidator;
import com.walmart.international.wallet.payment.dto.request.billpay.FetchBillPayPaymentInstrumentsRequest;
import com.walmart.international.wallet.payment.dto.response.billpay.FetchBillPayPaymentInstrumentsResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.*;

@ExtendWith(SpringExtension.class)
public class BillPaymentControllerImplIntegrationTest {

    @Mock
    private BillPaymentService billPaymentService;

    @Mock
    private WPSAuthValidator wpsAuthValidator;

    @InjectMocks
    private BillPaymentControllerImpl billPaymentController;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testFetchBillPayPaymentInstruments() throws ApplicationException {
        // Arrange
        FetchBillPayPaymentInstrumentsRequest request = new FetchBillPayPaymentInstrumentsRequest();
        request.setCustomerAccountId(12345L);
        MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
        FetchBillPayPaymentInstrumentsResponse expectedResponse = new FetchBillPayPaymentInstrumentsResponse();

        when(billPaymentService.fetchBillPayPaymentInstruments(request, headers)).thenReturn(expectedResponse);

        // Act
        FetchBillPayPaymentInstrumentsResponse response = billPaymentController.fetchBillPayPaymentInstruments(request, headers);

        // Assert
        assertNotNull(response);
        verify(wpsAuthValidator, times(1)).validateHeaderUserId("12345", headers);
        verify(billPaymentService, times(1)).fetchBillPayPaymentInstruments(request, headers);
    }

    // Additional test cases for other methods can be added similarly
}
