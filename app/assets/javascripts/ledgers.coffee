#
# Calls functions after page has completely loaded
$(document).on 'turbolinks:load', ->
    #
    # adds an onclick event delegator to watch for clicks in description
    $("#ledger").on("click", "td[id*=-description]", (event) ->
        $(this).text($(this).text().trim());
        toggleText(this, $(this.parentNode).data('description').trim(), 30);
    );
    #
    # shorten description in all cells initially
    $("#ledger").find('td[id*=-description]').each ->
        event = jQuery.Event('click');
        event.target = this;
        $("#ledger").trigger(event);
#
# toggles text based on the content length
@toggleText = (element, fullText, len) ->
    return if fullText.length <= len;
    #
    if $(element).text().length == fullText.length
        $(element).text(fullText.slice(0, len-4) + '...');
    else
        $(element).text(fullText);
