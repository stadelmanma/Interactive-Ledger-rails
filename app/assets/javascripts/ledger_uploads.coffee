#
# adds an event to disable the fields on a transaction marked for deletion
$(document).on 'turbolinks:load', ->
    # get all rows
    $('tr').each ->
        checkbox = this.querySelector('[type=checkbox][name*=_destroy]')
        return unless checkbox
        func = disable_inputs.bind(null, this, checkbox)
        checkbox.addEventListener('click', func)
#
# this function disables all child input elements except the checkbox used to toggle
@disable_inputs = (row, checkbox) ->
    inputs = $(row).find('input').not('[name*=destroy]')
    inputs.each -> this.disabled = checkbox.checked
