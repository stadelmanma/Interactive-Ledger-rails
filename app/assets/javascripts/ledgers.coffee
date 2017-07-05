#
# Calls functions after page has completely loaded
$(document).on 'turbolinks:load', ->
    #
    # adds an onclick event delegator to watch for clicks in description
    $("#ledger").on("click", "td[id*=-description]", (event) ->
        toggleText(this, 30);
    );
    #
    # shorten description in all cells initially
    $("[id*=-description]").each -> toggleText(this, 30)
#
# toggles text based on the content length
@toggleText = (element, len) ->
    full_content = element.parentNode.dataset.description
    content_len = element.textContent.length
    #
    if content_len > len
        element.textContent = full_content.slice(0, len-4) + '...'
    else
        element.textContent = full_content
