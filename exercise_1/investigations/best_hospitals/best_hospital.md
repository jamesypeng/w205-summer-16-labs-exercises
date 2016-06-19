### Process Care Domain
According to CMS website, [Process Care Domain](https://www.medicare.gov/hospitalcompare/data/clinical-process-of-care.html) contains 8 measurements,

* AMI-7a: Heart attack patients given fibrinolytic medication within 30 minutes of arrival
* PN-6: Pneumonia patients given the most appropriate initial antibiotic(s)
* SCIP-Card-2: Surgery patients who were taking heart drugs called beta blockers before coming to the hospital, who were kept on the beta blockers during the period just before and after their surgery
* SCIP-VTE-2: Patients who got treatment at the right time (within 24 hours before or after their surgery) to help prevent blood clots after certain types of surgery
* SCIP–Inf–2: Surgery patients who are given the right kind of antibiotic to help prevent infection
* SCIP–Inf–3: Surgery patients whose preventive antibiotics are stopped at the right time (within 24 hours after surgery)
* SCIP–Inf–9: Surgery patients whose urinary catheters were removed on the first or second day after surgery
* IMM-2: Patients assessed and given influenza vaccination

However, there are only few hospitals having data for the AM_7a procedure, so I use the other 7 measurement scores.

### Outcome Domain

There are 9 outcome domain measure scores, including MORT-30-AMI, MORT-30-HF, MORT-30-PN, PSI-90, HAI-1, HAI-1_, HAI-2, HAI-3 , HAI-4, and Combined SSI.

I identify the best hospital based on the following criteria
* Most of the hospitals did not report scores on all measurements. I filter the hospitals which have at least report 8 measurements, and none of the measurements has score of zero.
* Sort by average score, then the standard deviation. The standard deviation is a measurement of process and outcome consistency. The lesser the standard deviation is, the more consistency the hospital quality is. 


