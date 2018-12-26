module.exports = {
    root: true,
    parserOptions: {
      sourceType: 'module'
    },
    env: {
        es6: true,
        node: true,
    },
    extends: 'airbnb-base',
    rules: {
      'no-console': 0,
      'no-await-in-loop': 0,
      'no-loop-func': 0,
      'no-param-reassign': 0,
      'no-mixed-operators': 0,
      'import/no-dynamic-require': 0,
      'import/no-extraneous-dependencies': ['error', {
        'optionalDependencies': ['test/unit/index.js']
      }],
    },
};
