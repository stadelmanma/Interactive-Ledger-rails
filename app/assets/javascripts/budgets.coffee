#
# adds an event to disable the fields on a transaction marked for deletion
$(document).on 'turbolinks:load', ->
    #
    # adds an onclick event delegator to watch to clicks in description
    $("#add-ledger-select").on("click", (event) ->
        addLedgerSelect();
    );
#
# this function disables all child input elements except the checkbox used to toggle
@addLedgerSelect = () ->
    console.log('Adding a ledger select entry')
    url = '/budgets/add-budget-ledger-select?child_index='
    url += $('#budget-ledgers-container').find('li').length
    #
    success = (html) ->
        $(html).appendTo('#budget-ledgers-container')
    failure = (_, type, exception) ->
        console.error(type)
        console.dir(exception)
    args = {
        type: 'GET',
        dataType: 'html',
        error: failure,
        success: success,
        url: url
    }
    #
    $.ajax(args)
