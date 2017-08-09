#
# Calls functions after page has completely loaded
$(document).on 'turbolinks:load', ->
    #
    # adds an onclick event to show transaction details below the table
    $("[id^=dupe-row]").on("click", (event) ->
        showTransaction(this);
    );
#
# toggles text based on the content length
@showTransaction = (row) ->
    url = "/transactions/#{$(row).data('id')}/details";
    #
    success = (html) ->
        $('#transaction-details-container').html(html);
    #
    failure = (_, type, exception) ->
        console.error(type);
        console.dir(exception);

    args = {
        type: 'GET',
        dataType: 'html',
        error: failure,
        success: success,
        url: url
    }
    #
    $.ajax(args);
