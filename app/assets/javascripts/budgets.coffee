#
# adds an event to disable the fields on a transaction marked for deletion
$(document).on 'turbolinks:load', ->
    #
    # add onclick to all comments fields in the budget table view
    $('.budget').on('click', 'td.comments', (event) ->
        toggleText(this, $(this.parentNode).data('comments').trim(), 30);
    );
    #
    # shorten comments in all cells initially
    $('.budget td.comments').each ->
        event = jQuery.Event('click');
        event.target = this;
        fullText = $(this).text().trim();
        $(this).text(fullText);
        $('.budget').trigger(event);
    #
    # adds an onclick event to add another ledger field to the budget form
    $('#add-ledger-select').on('click', (event) ->
        addLedgerSelect();
    );
    #
    # adds an onclick event to add another exepense row to the budget form
    $('#add-budget-expense').on('click', (event) ->
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
@addBudgetExpense = (dateIncrement, expenseParams) ->
    table = $('#budget-expenses-container')
    childIndex = $(table).find('tr').length - 1
    #
    success = (html) ->
        row = $(html).appendTo(table)
        repeatButton = $(row).find('button.dupe-expense-fields')
        repeatSelect = $(row).find('select.dupe-expense-fields')
        #
        $(repeatButton).click(repeatExpenseEvery.bind(repeatSelect))
    failure = (_, type, exception) ->
        console.error(type)
        console.dir(exception)
    #
    args = {
        type: 'GET',
        dataType: 'html',
        error: failure,
        success: success,
        url: '/budgets/add-budget-expense',
        data: {
            child_index: childIndex,
            date_increment: dateIncrement,
            budget: {budget_expenses_attributes: expenseParams}
        }
    }
    #
    $.ajax(args)

#
# Implements repeat row N times functionality during creation of budget
# expenses.
@repeatExpenseEvery = () ->
    row = $(this).closest('tr')
    period = $(this).val()
    #
    # pull data from the inputs in the row
    data = {}
    $($(row).find('input[name]').serializeArray()).each (index, obj) ->
        name = obj.name.match(/\[([a-zA-Z_]+?)\]$/)[1]
        data[name] = obj.value;
    #
    # increment date
    if (isNaN(new Date(data['date'])))
        return
    else if (period == 'weekly')
        increment = '7.days'
    else if (period == 'biweekly')
        increment = '14.days'
    else if (period == 'monthly')
        increment = '1.month'
    else
        return
    #
    addBudgetExpense(increment, data)
