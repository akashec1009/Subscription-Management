import { LightningElement, track} from 'lwc';
import fetchProducts from '@salesforce/apex/ProductSelectionController.fetchProducts'

export default class ProductSelection extends LightningElement {
    @track searchTerm = '';
    @track minPrice = null;
    @track maxPrice = null;
    @track minRating = null;
    @track inStockOnly = false;
    @track product = [];
    @track isLoading = false;
    @track error = null;

    handleSearchChange(event){
        this.searchTerm = event.target.value;
    }
    handleMinPriceChange(event){
        this.minPrice = event.target.value ? parseFloat(event.target.value) : null;
    }
    handleMaxPriceChange(event){
        this.maxPrice = event.target.value ? parseFloat(event.target.value) : null;
    }
    handleMinRatingChange(event){
        this.minRating = event.target.value ? parseFloat(event.target.value) : null;
    }
    handleInStockToggle(event){
        this.inStockOnly = event.target.checked;
    }
    fetchFilteredProducts(){
        this.isLoading = true;
        this.error = null;
        fetchProducts({
            searchTerm: this.searchTerm,
            minPrice: this.minPrice,
            maxPrice: this.maxPrice,
            minRating: this.minRating,
            inStockOnly:this.inStockOnly
        })
        .then((result) => {
            this.product = result;
            this.isLoading = false;
        })
        .catch((error) => {
            this.error = error.body ? error.body.message : error.message;
            this.isLoading = false;
        });
    }
      handleProductSelection(event){
        const selectedProductId = event.target.dataset.id;
         // Fire a custom event to notify the parent component
        const selectEvent = new CustomEvent('product select', {
            detail : { productId : selectedProductId }
        });
        this.dispatchEvent(selectEvent);
    }
}