import Perfume from 'perfume.js';

/* eslint-disable no-new */
new Perfume({
  analyticsTracker: (options) => {
    const { metricName, data, navigatorInformation } = options;
    const metricNames = [
      'fp',
      'fcp',
      'lcp',
      'lcpFinal',
      'fid',
      'cls',
      'clsFinal',
      'tbt',
      'tbt10S',
      'tbtFinal',
    ];

    if (window.dataLayer && metricNames.includes(metricName)) {
      window.dataLayer.push({
        event: 'perfumeJs',
        category: 'perfume.js',
        action: metricName,
        label: navigatorInformation.isLowEndExperience
          ? 'lowEndExperience'
          : 'highEndExperience',
        // Google Analytics metrics must be integers, so the value is rounded
        value: metricName === 'cls' ? data * 1000 : data,
      });
    }
  },
});
