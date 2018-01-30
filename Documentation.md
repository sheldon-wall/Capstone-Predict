# Run Book - Predict Next Word with Semantic Bias

### Capstone Project - Version 1.0 - January 28, 2018
### Sheldon Wall

This application predicts the next word(s) upon examining words entered in the _**sentence**_ field.

### Quick Start

Start typing in the sentence field and watch the predicted next words change in the table below while you type.

### Options

To see more than a default of 5 words - simply increase the number in the **Num Words** field shown in the side panel.  

To show more than the **predictor** and (**prob**)ability fields in the table - simply select additional options under the **Columns to show** area in the side panel.

If you wish to increase the likelihood (bias) of showing words with a positive sentiment then click on the **Positive** button in the **Choose Sentiment Bias** side panel option. Choose the **Negative** sentiment button to bias the results in the opposite manner.

If you wish the increase the strength of that bias then move **Bias Strength** slider higher.  

### User Beware
A _**very**_ simple _Negation Voting_ method has been used for polarity shifting in sentiment classification.  Please review for accurate results when you use polarity shifters such as ("not", "no", "yet", "never", "none", "nobody", "nowhere", "nothing", "neither, etc.)

