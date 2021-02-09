module.exports = {
  extends: 'stylelint-config-gds/scss',
  rules: {
    'max-nesting-depth': null,
    'selector-no-qualifying-type': [true, { ignore: ['class'] }],
    'selector-max-id': 1,
    'declaration-block-single-line-max-declarations': 1,
    'declaration-no-important': false,
  },
};
