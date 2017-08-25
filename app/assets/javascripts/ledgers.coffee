#
# Calls functions after page has completely loaded
$(document).on 'turbolinks:load', ->
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
    # add handlers to ledger-summary 'more' links
    $('.ledger-summary table a').each ->
        $(this).click(showSubcategories.bind(null, this));
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
@showSubcategories = (link) ->
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
