var chalk = require('chalk');
var fs = require('fs');

fs.readFile('./test-data.json', 'utf8', function (err, data) {
    if (err) {
        console.error(chalk.red(`Failed: ${err.message}`));
        throw err;
    }
    test_data = JSON.parse(data);

    for (key in test_data) {
        test_case = test_data[key];
        if (test_case['pre-release'] === null) {
          var pre_release_str = null;
        } else {
          var pre_release_str = `"${test_case['pre-release']}"`;
        }

        if (test_case.build === null) {
          var build_str = null;
        } else {
          var build_str = `"${test_case.build}"`;
        }

        // console.log(chalk.blue(
        //     `semver_parse_verify("${key}"`
        //     + ` ${test_case['is-valid']}`
        //     + ` ${test_case.major} ${test_case.minor} ${test_case.patch}`
        //     + ` "${test_case['pre-release']}" "${test_case.build}")`));

        console.log(chalk.blue(
            `semver_parse_verify("${key}"`
            + ` ${test_case['is-valid']}`
            + ` ${test_case.major} ${test_case.minor} ${test_case.patch}`
            + ` ${pre_release_str} ${build_str})`));
    }
});
