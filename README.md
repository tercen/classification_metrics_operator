# TClassification metrics operator

##### Description

This operator returns precision, recall and F1-score of a classification.

##### Usage

Input projection|.
---|---
`y-axis`        | numeric, measurement
`row`           | character, true label 
`colors`        | character, predicted label 

Output relations|.
---|---
`label`        | label / cluster
`precision`        | precision, per label
`recall`        | recall, per label
`f1`        | f1 score, per label

##### Details

[Precision and recall on Wikipedia](https://en.wikipedia.org/wiki/Precision_and_recall).

[F-score on Wikipedia](https://en.wikipedia.org/wiki/F-score).

##### See Also

[clustering_metrics_operator](https://github.com/tercen/clustering_metrics_operator)

