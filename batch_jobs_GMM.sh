for cv in {0..44}
do
    for minn in {10..45..1}
    do
        jobid="GMMfit_cv_"$cv"_n_"$minn
        echo '#!/bin/bash'>subjob.bash
        echo '#PBS -q celltypes'>>subjob.bash
        echo '#PBS -N '${jobid//./-} >>subjob.bash
        echo '#PBS -m a'>>subjob.bash
        echo '#PBS -r n'>>subjob.bash
        echo '#PBS -l ncpus=4'>>subjob.bash
        echo '#PBS -l mem=2g,walltime=0:45:00'>>subjob.bash
        echo '#PBS -o /allen/programs/celltypes/workgroups/mousecelltypes/Rohan/logs/'${jobid//./-}'.out'>>subjob.bash
        echo '#PBS -j oe'>>subjob.bash

        echo 'cd /allen/programs/celltypes/workgroups/mousecelltypes/Rohan/code/Patchseq-AE-Bioarxiv/'>>subjob.bash
        echo 'source activate tf21-cpu'>>subjob.bash
        echo 'python -m analysis_denovo_script' \
                        ' --representation_pth TE_aug_decoders' \
                        ' --exp_name gmm_fits_us' \
                        ' --cvfold '$cv \
                        ' --alpha_T 1.0'\
                        ' --alpha_E 1.0'\
                        ' --lambda_TE 1.0'\
                        ' --min_component '$minn
        >>subjob.bash
        echo '...'
        sleep 1
        wait
        qsub subjob.bash
        echo 'Job: '${jobid//./-}' '
        #cat subjob.bash
    done
done
rm subjob.bash