{*
 * Classic theme doesn't use this subtemplate, feel free to do whatever you need here.
 * This template is generated at each ajax calls.
 * See ProductListingFrontController::getAjaxProductSearchVariables()
 *}
<div id="js-product-list-bottom" class="products-selection">
	 <div class="row sort-by-row">
      {block name='display_view'}
          <div class="display-view hidden-sm-down">
                <label>{l s='View' d='Shop.Nayciabeauty'}</label>
                <span class="material-icons view-item show_grid active">&#xE42A;</span>
                <span class="material-icons view-item show_list">&#xE8EF;</span>
          </div>
      {/block}
      {block name='sort_by'}
        {include file='catalog/_partials/sort-orders.tpl' sort_orders=$listing.sort_orders}
      {/block}
      {if !empty($listing.rendered_facets)}
        <div class="hidden-lg-up filter-button">
          <button id="search_filter_toggler" class="btn btn-secondary">
            {l s='Filter' d='Shop.Theme.Actions'}
          </button>
        </div>
      {/if}
      {block name='pagination'}
        {include file='_partials/pagination.tpl' pagination=$listing.pagination}
      {/block}
	</div>
</div>
