Important 

BillerController.java public interface BillerController {

    @GetMapping(value = "/v1/biller/categories", produces = "application/json")
    BillerCategoriesResponse getBillerCategories(@RequestParam(defaultValue = "1") int billerCategoryVersion);
}
………………………..
BillerCategoriesResponse.java
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class BillerCategoriesResponse {

    private List<BillerCategoryDTO> categories;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'")
    private Date billerCategoryDataLastUpdatedAt;

}

………………………..
BillerControllerImpl.java
@RestController
public class BillerControllerImpl implements BillerController {

    @Autowired
    private BillerService billerService;

    @Autowired
    private BillerPromotionService billerPromotionService;

    @ManagedConfiguration
    private WalletPaymentServiceConfiguration walletPaymentServiceConfiguration;

    @Override
    public BillerCategoriesResponse getBillerCategories(int billerCategoryVersion) {
        return billerService.getBillerCategories(billerCategoryVersion);
    }
}
………………………..
BillerService.java
public interface BillerService {

    BillerCategoriesResponse getBillerCategories(int billerCategoryVersion);

}
………………………..
BillerServiceImpl.java
@Component
@Slf4j
public class BillerServiceImpl implements BillerService {

    @Autowired
    private BillerCoreService billerCoreService;


    @Override
    public BillerCategoriesResponse getBillerCategories(int billerCategoryVersion) {
        return getBillerCategoriesMapFromCache(billerCategoryVersion);
    }

    private BillerCategoriesResponse getBillerCategoriesMapFromCache(int billerCategoryVersion) {
        List<BillerCategory> billerCategoriesList;
        Date billerCategoryDataLastUpdatedAt;

        billerCategoriesList = billerCoreService.getBillerCategoriesList(billerCategoryVersion);
        billerCategoryDataLastUpdatedAt = billerCoreService.fetchBillerCategoryDataLastUpdatedAtTimestamp();

        if (CollectionUtils.isNotEmpty(billerCategoriesList)) {
            return BillerCategoriesResponse.builder()
                    .categories(billerDTOMapper.mapBillerCategoriesListToBillerCategoryDTOList(billerCategoriesList))
                    .billerCategoryDataLastUpdatedAt(billerCategoryDataLastUpdatedAt)
                    .build();
        }
        return BillerCategoriesResponse.builder()
                .categories(new ArrayList<>())
                .build();
    }
}
………………………..
BillerCategory.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BillerCategory implements Serializable {
    private static final long serialVersionUID = -759311152096064473L;
    private UUID id;
    private String categoryName;
    private String imageUrl;
    private int billerCategoryVersion;
    private Boolean hasEnabledBillers = false;
    private Boolean hasNewBillers = false;
    private List<Biller> billers;
}

………………………..
BillerCoreService.java 
public interface BillerCoreService {
List<BillerCategory> getBillerCategoriesList(Integer billerCategoryVersion);
void reloadCacheForBillerCategoryData(List<Integer> billerCategoryVersions);

}

………………………..
BillerRepository.java
@Repository
public interface BillerRepository extends JpaRepository<BillerDO, UUID>, CustomBillerRepository {
    Optional<BillerDO> getByBillerId(UUID billerId);

    Optional<BillerDO> getByProcessorBillerId(String processorBillerId);

    Optional<BillerDO> getByBillerIdAndEnabled(UUID billerId, Boolean enabled);

    Optional<BillerDO> getByProcessorBillerIdAndEnabled(String processorBillerId, Boolean enabled);

    @Query("select distinct b from BillerDO b left join fetch b.subBillers sb " +
            "where b.popularBillerSequenceNumber > 0 " +
            "order by b.popularBillerSequenceNumber")
    List<BillerDO> getPopularBillersAndSubBillers();
}

………………………..
BillerSearchRepository
BillerCategoryVersionMappingRepository
BillerDO
BillerCategoryVersionMappingDO

………………………..
………………………..
