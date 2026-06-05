/**
 * Reproduction script for issue #6:
 * validate-number-range rejects negative values before range check.
 */
'use strict';

function validateNumberRangeBroken(value, param) {
    if (value === '' || value == null) {
        return true;
    }

    const isNumeric = /^(?:\d+\.?\d*|\.\d+)$/.test(value);

    if (!isNumeric) {
        return false;
    }

    const numValue = parseFloat(value);
    const dataAttrRange = /^(-?[\d.,]+)?-(-?[\d.,]+)?$/;
    const m = dataAttrRange.exec(param);

    if (!m) {
        return true;
    }

    const from = m[1] === '' ? null : parseFloat(m[1]);
    const to = m[2] === '' ? null : parseFloat(m[2]);

    return (from === null || numValue >= from) && (to === null || numValue <= to);
}

function validateNumberRangeFixed(value, param) {
    if (value === '' || value == null) {
        return true;
    }

    const isNumeric = /^-?(?:\d+\.?\d*|\.\d+)$/.test(value);

    if (!isNumeric) {
        return false;
    }

    const numValue = parseFloat(value);
    const dataAttrRange = /^(-?[\d.,]+)?-(-?[\d.,]+)?$/;
    const m = dataAttrRange.exec(param);

    if (!m) {
        return true;
    }

    const from = m[1] === '' ? null : parseFloat(m[1]);
    const to = m[2] === '' ? null : parseFloat(m[2]);

    return (from === null || numValue >= from) && (to === null || numValue <= to);
}

const value = '-5';
const range = '-10.00-100.00';

console.log('Input:', value);
console.log('Range:', range);
console.log('Broken implementation:', validateNumberRangeBroken(value, range));
console.log('Fixed implementation:', validateNumberRangeFixed(value, range));

if (!validateNumberRangeBroken(value, range) && validateNumberRangeFixed(value, range)) {
    console.log('\nReproduction confirmed: negative values fail before range validation.');
    process.exit(0);
}

console.error('\nUnexpected reproduction result.');
process.exit(1);
