#
# adds an event to disable the fields on a transaction marked for deletion
$(document).on 'turbolinks:load', ->
    #
    # adds an onclick event to add another ledger field to the budget form
    $("#add-ledger-select").on("click", (event) ->
        addLedgerSelect();
    );
    #
    # adds an onclick event to add another exepense row to the budget form
    $("#add-budget-expense").on("click", (event) ->
        addBudgetExpense();
    );
#
# this function handles sending and receiving an AJAX response to add a ledger
# field to the form
@addLedgerSelect = () ->
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
#
# this function handles sending and receiving an AJAX response to add another
# row of budget expense fields field to the form
@addBudgetExpense = () ->
    url = '/budgets/add-budget-expense?child_index='
    url += $('#budget-expenses-container').find('tr').length - 1
    #
    success = (html) ->
        $(html).appendTo('#budget-expenses-container')
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
