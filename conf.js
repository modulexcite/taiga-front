exports.config = {
    seleniumAddress: 'http://localhost:4444/wd/hub',
    specs: ['integration/**/*spec.js'],
    framework: 'mocha',
    mochaOpts: {
        timeout: 5000
    },
    // onPrepare: function() {
    //     return browser.executeScript(function() {
    //         document.cookie='cookieConsent=1';
    //     });
    // }
    // onPrepare: function() {
    //     var username = $('input[name="username"]');
    //     username.sendKeys('admin');

    //     var password = $('input[name="password"]');
    //     password.sendKeys('123123');

    //     $('.submit-button').click();

    //     return browser.driver.wait(function() {
    //         return browser.driver.getCurrentUrl().then(function(url) {
    //             return url === 'http://localhost:9001/';
    //         });
    //     }, 10000);
    // }
}
