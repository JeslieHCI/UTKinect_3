function [] = generate_features(directory, dataset, feature_type, n_desired_frames, class)
        
    load(['data/', dataset, '/skeletal_data'])
    
    if class == 1
        load(['data/', dataset, '/body_model_arm'])
    elseif class == 2
        load(['data/', dataset, '/body_model_leg'])
    elseif class == 3
        load(['data/', dataset, '/body_model_spine'])
    end

    if (strcmp(dataset, 'UTKinect'))
        n_subjects = 10;    % 10 subjects performed by 10different subjects
        n_actions = 10;     % each subject performed every action twice
        n_instances = 2;

        % there 199 actions sequences
        n_sequences = length(find(skeletal_data_validity));        

        features = cell(n_sequences, 1);
        action_labels = zeros(n_sequences, 1);
        subject_labels = zeros(n_sequences, 1);
        instance_labels = zeros(n_sequences, 1); 

        count = 1;
        for subject = 1:n_subjects
            for action = 1:n_actions
                for instance = 1:n_instances
                    % justify whether the data is empty skeletal_data_validity is a matrix full of 1,0.
                    % 1 represent that that is a action, and 0 represent that isn't a action
                    % so this can explain why there are 199 actions sequences not 200
                    if (skeletal_data_validity(action, subject, instance))                    

                        joint_locations = skeletal_data{action, subject, instance}.joint_locations;    
                        
                        if class == 1
                            features{count} = get_features(feature_type, joint_locations, body_model_arm, n_desired_frames);
                        elseif class == 2
                            features{count} = get_features(feature_type, joint_locations, body_model_leg, n_desired_frames);
                        elseif class == 3
                            features{count} = get_features(feature_type, joint_locations, body_model_spine, n_desired_frames);
                        end
                        
                        action_labels(count) = action;
                        subject_labels(count) = subject;
                        instance_labels(count) = instance;

                        count = count + 1;
                    end
                end
            end
        end

        save([directory, '/features'], 'features', '-v7.3');
        save([directory, '/labels'], 'action_labels', 'subject_labels', 'instance_labels');

    elseif (strcmp(dataset, 'Florence3D'))    

        n_sequences = length(skeletal_data);

        features = cell(n_sequences, 1);
        action_labels = zeros(n_sequences, 1);
        subject_labels = zeros(n_sequences, 1);

        for count = 1:n_sequences      

            joint_locations = skeletal_data{count}.joint_locations;
            features{count} = get_features(feature_type, joint_locations, body_model, n_desired_frames);

            action_labels(count) = skeletal_data{count}.action;       
            subject_labels(count) = skeletal_data{count}.subject;        

        end

        save([directory, '/features'], 'features', '-v7.3');
        save([directory, '/labels'], 'action_labels', 'subject_labels');

        
    elseif (strcmp(dataset, 'MSRAction3D'))
                
        n_subjects = 10;
        n_actions = 20;
        n_instances = 3;

        n_sequences = length(find(skeletal_data_validity));        

        features = cell(n_sequences, 1);
        action_labels = zeros(n_sequences, 1);
        subject_labels = zeros(n_sequences, 1);
        instance_labels = zeros(n_sequences, 1); 

        count = 1;
        for subject = 1:n_subjects
            for action = 1:n_actions
                for instance = 1:n_instances
                    if (skeletal_data_validity(action, subject, instance))                    

                        joint_locations = skeletal_data{action, subject, instance}.joint_locations;        
                        features{count} = get_features(feature_type, joint_locations, body_model, n_desired_frames);
                        action_labels(count) = action;       
                        subject_labels(count) = subject;
                        instance_labels(count) = instance;

                        count = count + 1;
                    end
                end
            end
        end

        save([directory, '/features'], 'features', '-v7.3');
        save([directory, '/labels'], 'action_labels', 'subject_labels', 'instance_labels');        

    else    
        error('Unknown dataset');
    end
    
end

      
