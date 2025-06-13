# martinEA2025persistent
Source code from (Martin et al., 2025)

# Network clamp persistent activity 

# Authors

Erwan Martin1,†, Lawrence Oprea1,†, Samuel Mestern2, Wataru Inoue3,a,‡, and Lyle E. Muller1,b,‡

1Department of Mathematics, Western University, Canada
2Department of Physiology and Pharmacology, Western University, Canada
†These authors contributed equally
‡Co-senior authors 

# Description
Working memory is crucial for cognition as it is at the basis of most cognitive functions. Attractor models have been crucial to provide fundamental insights into how recurrent neural circuits would be able to maintain persistent activity. Since the development of the canonical ring attractor model, several implementation have been proposed to improve this framework, but to validate those models we need a method to test them against biological reality. We hypothesized that a large-scale attractor model with clustered excitatory population would be able to present a persistent bump pattern of activity recapitulating the *in vitro* activity of the prefrontal cortex (PFC), but it would also generates synaptic signals able to evoke the predicted response in biological neurons *in vitro*. To test this, we developed the network clamp method, based on dynamic clamp, it consists in stimulating *in vitro* eurons with conductance based synpatic signals generated within spiking neural network models. Using the network clamp method, we inject mouse mPFC pyramidal neurons *in vitro* with synaptic signals extracted from a replication of the canonical ring attractor model, but this resulted in a stimulation that was overwhelming for biological neurons. We then developed an attractor model composed of 50 000 excitatory and inhibitory neurons with the excitatory population presenting a clustered connectivity pattern. Injecting the synaptic signals from this model into neurons in vitro evoked voltage response close to the model's prediction. This network model method allows to test model driven hypotheses and can be used to study different contexts of network dynamics and their underlying mechanisms. This approach provides a unique opportunity to study subthreshold response of *in vitro* neurons to "*in vivo*-like" context. And this unique perspective is combined to the extensive control of *in vitro* experimental condition. Network clamp method enable promising application is pharmacological testing. As a practical demonstration, we tested how the response of the mouse mPFC pyramidal neurons to network clamp stimulation is modulated by dopamine.  

# Dependencies
NETSIM 

# Usage 
Run the scripts in the code folder to generate the plots from the paper.

# Testing 
Tested using Python 3.12.4 and MATLAB 2024b.