basic proximal mapping:
	prox_fro.m
	prox_l1.m
	prox_nuclear.m

PCP algorithms:
	root_pcp.m
	stable_pcp.m

Experiment -- simulated data, comparing root PCP and stable PCP:
	simulation_experiment_varying_sigma.m
	varying_sigma_plot.m
	simulation_experiment_varying_n.m
	varying_n_plot.m
	(not used) simulation_experiment.m

Experiment -- real data with added noise: 
	data from 
	real_data_exp.m
	process_video_results.m
	(not used) create_video.m: create video of original, L_root, S_root, L_stable, S_stable
	(not used) video_to_image.m

Experiment -- real data denoising:
	low light video:
		-- data from https://github.com/cchen156/Seeing-Motion-in-the-Dark
		-- real_data_denoising.m
	oct:
		-- data from https://academiccommons.columbia.edu/doi/10.7916/d8-2g57-b521
		-- oct_denoising.m
	real_data_denoising_video.m: create figures/videos of original, L, S, L+S, L+S-original
	video_crop.m: crop and down sample the data

Experiment -- simulated data, optimal mu:
	simulation_exp_varying_mu_p/sigma/rho/n.m
	varying_mu_plot.m






