module.exports = {
  extends: 'stylelint-config-gds/scss',
  rules: {
    'max-nesting-depth': null,
    'selector-no-qualifying-type': [true, { ignore: ['class', 'attribute'] }],
    'selector-max-id': 1,
    'declaration-block-single-line-max-declarations': 1,
    'color-named': 0,
  },
};
