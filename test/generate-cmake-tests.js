const chalk = require('chalk');
const fs = require('fs');

function valueOrNull(value) {
  return (value === null) ? 'null' : `"${value}"`;
}

fs.readFile('./test-data.json', 'utf8', (err, data) => {
  if (err) {
    console.error(chalk.red(`Failed: ${err.message}`));
    throw err;
  }
  const testData = JSON.parse(data);

  Object.entries(testData).forEach(([key, value]) => {
    console.log(chalk.blue(
      `semver_parse_verify("${key}"`
      + ` ${value['is-valid']}`
      + ` ${valueOrNull(value.major)} `
      + ` ${valueOrNull(value.minor)}`
      + ` ${valueOrNull(value.patch)}`
      + ` ${valueOrNull(value['pre-release'])}`
      + ` ${valueOrNull(value.build)})`,
    ));
  });
});
