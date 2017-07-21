#
# adds event to create a new set of category initializers fields
$(document).on 'turbolinks:load', ->
    #
    $("#add-category-initializer").on("click", (event) ->
        addCategoryInitializer();
    );
    #
    # strip out the number from the params name so a simple array is submitted
    # instead of a hash with the id as the key
    $('#category-initializers-container').find('input').each ->
        name = $(this).attr('name');
        $(this).attr('name', name.replace(/\[\d+\]/, '[]'));
#
# this function handles sending and receiving an AJAX response to add a
# set of initializer fields field to the form
addCategoryInitializer = () ->
    url = '/category_initializers/add-category-initializer';
    #
    success = (html) ->
        $(html).appendTo('#category-initializers-container');
        row = $('#category-initializers-container').find('tr:last-of-type');
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
