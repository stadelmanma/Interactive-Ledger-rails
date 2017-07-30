#
# adds an event to disable the fields on a transaction marked for deletion
$(document).on 'turbolinks:load', ->
    # get all rows and add event handler to disable fields when delete checked
    $('tr').each ->
        checkbox = this.querySelector('[type=checkbox][name*=_destroy]');
        return unless checkbox;
        func = disableInputs.bind(null, this, checkbox);
        checkbox.addEventListener('click', func);
    # add event handlers to build and remove a datalist from an input
    $('[id*=category]').each ->
        $(this).focus(buildDataList.bind(this));
        $(this).blur(removeDataList.bind(this));
#
# this function disables all child input elements except the checkbox used to toggle
@disableInputs = (row, checkbox) ->
    disable = checkbox.checked;
    if disable
        $(row).find('input').not('[name*=destroy]').addClass('disabled');
    else
        $(row).find('input').not('[name*=destroy]').removeClass('disabled');
#
# this funtion adds a datalist to each category and subcategory input when
# they become active
@buildDataList = () ->
    # determine JSON request url based on input
    if this.name.match(/\[category\]/)
        url = location.pathname.replace(/ledger_uploads.*$/, 'categories.json');
    else if this.name.match(/\[subcategory\]/)
        url = location.pathname.replace(/ledger_uploads.*$/, 'subcategories.json');
    #
    # AJAX callback functions to process data and handler errors
    success = (input, json) ->
        # build and add datalist to DOM
        dataList = $('<datalist id="' + input.id + '-datalist' + '"/>');
        $(json).each ->
            dataList.append('<option value="' + this + '" />');
        $(input).attr('list', input.id + '-datalist');
        $(input).parent().append(dataList);
    #
    failure = (_, type, exception) ->
        console.error(type);
        console.dir(exception);
    #
    # build args and send AJAX query
    args = {
        type: 'GET',
        dataType: 'json',
        error: failure,
        success: success.bind(null, this),
        url: url
    }
    #
    $.ajax(args);
#
# this function removes a datalist from an element
@removeDataList = () ->
    $(this).siblings('datalist').remove();
