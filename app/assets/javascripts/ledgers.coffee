#
# Calls functions after page has completely loaded
$(document).on 'turbolinks:load', ->
    #
    # adds an onclick event to add category exclusion fields to the ledger form
    $('#add-category-exclusion').on('click', (event) ->
        addCategoryExclusion();
    );
    #
    # adds an onclick event delegator to watch for clicks in description
    $("#ledger").on("click", "td[id*=-description]", (event) ->
        toggleText(this, $(this.parentNode).data('description').trim(), 30);
    );
    #
    # shorten description in all cells initially
    $("#ledger").find('td[id*=-description]').each ->
        event = jQuery.Event('click');
        event.target = this;
        fullText = $(this).text().trim();
        $(this).text(fullText);
        $("#ledger").trigger(event);
    #
    # add handlers to show and hide additional subcategory information
    $('.ledger li > .subcategory-summary').closest('li').each ->
        subcats = $(this).find('.subcategory-summary');
        show_icon = $(this).find('.show-subcategories');
        hide_icon = $(this).find('.hide-subcategories');
        #
        $(show_icon).click ->
            $(show_icon).hide();
            $(hide_icon).show();
            $(subcats).show();
        #
        $(hide_icon).click ->
            $(hide_icon).hide();
            $(show_icon).show();
            $(subcats).hide();
    #
    # add handlers to ledger-summary 'more' links
    $('.ledger-summary table a').each ->
        $(this).click(showSummarySubcategories.bind(null, this));
#
# this function handles sending and receiving an AJAX response to add a ledger
# field to the form
@addCategoryExclusion = () ->
    container = $('#category-exclusions-container')
    url = '/category_exclusions/form_fields?child_index='
    url += container.find('div').length
    #
    success = (html) ->
        $(html).appendTo(container)
    #
    failure = (_, type, exception) ->
        console.error(type)
        console.dir(exception)
    #
    args = {
        type: 'GET',
        dataType: 'html',
        error: failure,
        success: success,
        url: url
    }
    #
    $.ajax(args)
#
# toggles text based on the content length
@toggleText = (element, fullText, len) ->
    return if fullText.length <= len;
    #
    if $(element).text().length == fullText.length
        $(element).text(fullText.slice(0, len-4) + '...');
    else
        $(element).text(fullText);

#
# shows a set of subcategory rows in the summary table
@showSummarySubcategories = (link) ->
    table = $(link).closest('table');
    rows = $(table).find("tr[data-parent-key=#{$(link).data('key')}]");
    #
    rows.each ->
        if $(this).is(':visible')
            $(link).text('More');
            $(this).hide();
        else
            $(link).text('Hide');
            $(this).show();
