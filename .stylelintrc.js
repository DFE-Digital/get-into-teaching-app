module.exports = {
  extends: 'stylelint-config-gds/scss',
  rules: {
    'max-nesting-depth': null,
    'selector-no-qualifying-type': [true, { ignore: ['class'] }],
    'selector-max-id': 1,
  },
};
