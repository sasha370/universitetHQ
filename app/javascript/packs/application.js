require('cocoon')
import "cocoon"

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap"
import "../trix-editor-overrides"



require("trix")
require("@rails/actiontext")
require("chartkick")
require("chart.js")
require("jquery")
require("jquery-ui-dist/jquery-ui")
import "youtube"

require("selectize")


// drag_drop
$(document).on('turbolinks:load', function () {
    $('.lesson-sortable').sortable({
        cursor: "grabbing",
        placeholder: "ui-state-highlight",

        update: function (e, ui) {
            let item = ui.item;
            let item_data = item.data();
            let params = {_method: 'put'};
            params[item_data.modelName] = {row_order_position: item.index()}
            $.ajax({
                type: 'POST',
                url: item_data.updateUrl,
                dataType: 'json',
                data: params
            });
        },
        stop: function (e, ui) {
            console.log("stop called when finishing sort of cards");
        }
    });


    $("video").bind("contextmenu", function () {
        return false;
    });

    // ТЕГИ
    if ($('.selectize')) {
        $('.selectize').selectize({
            sortField: 'text',
        });
    }

    $(".selectize-tags").selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        persist: false,

        create: function (input, callback) {
            $.post('/tags.json', {tag: {name: input}})
                .done(function (response) {
                    console.log(response)
                    callback({value: response.id, text: response.name});
                })
        }
    });


});
