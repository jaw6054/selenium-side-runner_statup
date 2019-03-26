#!/usr/bin/python

import json
import time
import re
from datetime import datetime
from datetime import timedelta

from prometheus_client import start_http_server, Gauge, Info, REGISTRY, Metric

# for name,dict_ in content.items():
#    print('the name of the dictionary is ', name)

class SeleniumCollector():
    def collect(self):
        logfile = open("/out/" + testSuite + ".json", "r")
        content = json.load(logfile)
        logfile.close()
        #
        startTime = Metric(
            'selenium_' + testSuite + '_startTime',
            'Selenium start time for suite ' + testSuite,
            'gauge'
        )
        dtm = datetime.utcfromtimestamp(content["startTime"]/1000)
        startTime.add_sample('selenium_' + testSuite + '_startTime', value = content["startTime"]/1000, labels = {})
        yield startTime
        #
        success = Metric(
            'selenium_' + testSuite + '_success',
            'Selenium success status for suite ' + testSuite,
            'gauge'
        )
        success.add_sample('selenium_' + testSuite + '_success', value = content["success"], labels = {})
        yield success
        #
        numPassedTests = Metric(
            'selenium_' + testSuite + '_numPassedTests',
            'Selenium number of passed tests for suite ' + testSuite,
            'gauge'
        )
        numPassedTests.add_sample('selenium_' + testSuite + '_numPassedTests', value = content["numPassedTests"], labels = {})
        yield numPassedTests
        #
        numFailedTests = Metric(
            'selenium_' + testSuite + '_numFailedTests',
            'Selenium number of failed tests for suite ' + testSuite,
            'gauge'
        )
        numFailedTests.add_sample('selenium_' + testSuite + '_numFailedTests', value = content["numFailedTests"], labels = {})
        yield numFailedTests
        #
        greyOut = 0
        for test in content["testResults"][0]["assertionResults"]:
            title = test["title"]
            status = test["status"]
            failureMessages = test["failureMessages"]

            if len(failureMessages) > 0:
               failureMessage = failureMessages[0]
            else:
               failureMessage = "blah"
            
            isGrey = bool(re.search("ss-gray-out", failureMessage))
            greyOut = greyOut + isGrey
        #
        numGrayOuts = Metric(
            'selenium_' + testSuite + '_numGrayOuts',
            'Selenium number of grayed-out tests for suite ' + testSuite,
            'gauge'
        )
        numGrayOuts.add_sample('selenium_' + testSuite + '_numGrayOuts', value = greyOut, labels = {})
        yield numGrayOuts

        #
        # message = Metric(
        #     'selenium_' + testSuite + '_message',
        #     'Selenium message for suite ' + testSuite,
        #     'info'
        # )
        # message.add_sample('selenium_' + testSuite + '_message', value = {"message": content["testResults"][0]["message"]}, labels = {})
        # yield message

if __name__ == '__main__':
    # Usage: json_exporter.py port endpoint
    start_http_server(9119)
    testSuite = "Zukunftsfonds"
    REGISTRY.register(SeleniumCollector())
    #
    while True: time.sleep(10)


