module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  extends: [
    'standard', 'prettier'
  ],
  
  parserOptions: {
    ecmaVersion: 12,
    sourceType: 'module'
  },
  parser: 'babel-eslint',
  plugins: [ "prettier"],

  rules: {
    "prettier/prettier": "error"
  }
}
