module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  extends: ['standard', 'prettier'],
  parserOptions: {
    ecmaVersion: 12,
    sourceType: 'module',
  },
  parser: '@babel/eslint-parser',
  plugins: ['prettier'],
  rules: {
    'prettier/prettier': [
      'error',
      {
        endOfLine: 'auto',
      },
    ],
  },
  ignorePatterns: ['polyfills/'],
  overrides: [
    {
      files: ['*_spec.js', '*spec_helper.js'],
      env: {
        jest: true,
      },
    },
  ],
  globals: {
    Turbolinks: 'readonly',
  },
};
