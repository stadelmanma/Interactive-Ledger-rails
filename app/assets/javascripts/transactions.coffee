#
# Calls functions after page has completely loaded
$(document).on 'turbolinks:load', ->
    #
    # adds double click event to show transaction in a new tab
    $('.transaction').on("dblclick", (event) ->
        showTransaction(this);
    );
    #
    # adds an onclick event to show transaction details below the table
    $("[id^=dupe-row]").on("click", (event) ->
        showDupeDetails(this);
    );

#
# navigates the page to the transaction itself in a new tab
@showTransaction = (row) ->
    url = "/transactions/#{$(row).data('id')}";
    window.open(url);

#
# toggles text based on the content length
@showDupeDetails = (row) ->
    url = "/transactions/#{$(row).data('id')}/details";
    #
    success = (html) ->
        $('#transaction-details-container').html(html);
    #
    failure = (_, type, exception) ->
        console.error(type);
        console.dir(exception);
    #
    args = {
        type: 'GET',
        dataType: 'html',
        error: failure,
        success: success,
        url: url
    }
    #
    $.ajax(args);
