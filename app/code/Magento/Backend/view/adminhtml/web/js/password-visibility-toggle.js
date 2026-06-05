/**
 * Copyright 2026 Adobe
 * All Rights Reserved.
 */

define([
    'jquery'
], function ($) {
    'use strict';

    return function (config, element) {
        var toggle = $(element),
            password = $(config.passwordSelector),
            label = toggle.find('[data-role="show-password-label"]');

        toggle.on('click', function () {
            var isHidden = password.attr('type') === 'password',
                buttonText = isHidden ? toggle.data('hide-label') : toggle.data('show-label'),
                accessibleText = isHidden ?
                    toggle.data('hide-password-label') :
                    toggle.data('show-password-label');

            password.attr('type', isHidden ? 'text' : 'password');
            toggle
                .attr({
                    'aria-label': accessibleText,
                    'aria-pressed': isHidden ? 'true' : 'false',
                    title: accessibleText
                });
            label.text(buttonText);
        });
    };
});
