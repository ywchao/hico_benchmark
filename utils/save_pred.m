function [] = save_pred(file_name, label_value, predicted_label, accuracy, prob_estimates)

res.label_value = label_value;
res.predicted_label = predicted_label;
res.accuracy = accuracy;
res.prob_estimates = prob_estimates;
save(file_name, 'res');

end
