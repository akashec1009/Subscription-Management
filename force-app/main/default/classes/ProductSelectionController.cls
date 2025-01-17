public with sharing class ProductSelectionController {
    /**
     * Fetch Available product based on optional filter
     * @param searchTerm String - optional serch term for product_Name__c
     * @param minPrice Decimal - Optional for minimun Price
     * @param macPrice Decimal - Optional for max Price
     * @param minRating Decimal - option for product_rating__c
     * @param inStockOnly boolean - Optional for stock availability
     * 
     */
    @AuraEnabled(cacheable = true)
    public static List<ProductWrapper> fetchProducts(String searchTerm, Decimal minPrice, Decimal maxPrice, Decimal minRating, boolean inStockOnly){
        try{
            //Base query to fetch Active product
            String query = 'SELECT Product_Name__c, Price__c, Product_Rating__c, Stock_Availability__c,Category__c FROM Product__c WHERE Stock_Availability__c = true ';

            //Dynamic Filtering
            if(string.isNotBlank(searchTerm)){
                query += 'AND Product_Name__c LIKE  \'%' + string.escapeSingleQuotes(searchTerm) + '%\'';
  
            }
            if(minPrice != null){
                query += ' AND Price__c >= :minPrice ';

            }
            if(maxPrice != null){
                query += 'AND Price__c <= :maxPrice ';

            }
            if(minRating != null){
                query += 'AND Product_Rating__c >= :minRating';

            }
            //Execute Query
            List<Product__c> products = Database.query(query);
            system.debug('after the query run......');
            system.debug(products);
            system.debug(query);


            //Map product into wrapper of LWC
            List<ProductWrapper> productWrappers = new List<ProductWrapper>();
            for(Product__c product : products){
                System.debug('before the product wrapper');
                productWrappers.add(new ProductWrapper(product));
                System.debug('search term wrapper');
            }
            return productWrappers;
        }catch(Exception ex){
            throw new AuraHandledException('Unable to fetch Product ' + ex.getMessage()); 
        }
    }
    /**
     * Inner class to structure product data for the LWC.
     */
    public class ProductWrapper {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public Decimal rating { get; set; }
        @AuraEnabled public Decimal price { get; set; }
        @AuraEnabled public Boolean stockAvailablity { get; set; }
    
    public ProductWrapper(Product__c product){
        this.id = product.Id;
        this.name = product.Product_Name__c;
        this.price = product.Price__c;
        this.rating = product.Product_rating__c;
        this.stockAvailablity = product.Stock_Availability__c;
    }
  }
}