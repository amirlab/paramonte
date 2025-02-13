!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!                                                                                                                            !!!!
!!!!    ParaMonte: Parallel Monte Carlo and Machine Learning Library.                                                           !!!!
!!!!                                                                                                                            !!!!
!!!!    Copyright (C) 2012-present, The Computational Data Science Lab                                                          !!!!
!!!!                                                                                                                            !!!!
!!!!    This file is part of the ParaMonte library.                                                                             !!!!
!!!!                                                                                                                            !!!!
!!!!    LICENSE                                                                                                                 !!!!
!!!!                                                                                                                            !!!!
!!!!       https://github.com/cdslaborg/paramonte/blob/main/LICENSE.md                                                          !!!!
!!!!                                                                                                                            !!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!>  \brief
!>  This module contains the **internal** classes and procedures for setting up the attributes of the ParaMonte library DRAM-MCMC samplers.<br>
!>
!>  \details
!>  For more information, see the description of the attributes within the bodies of their constructors in this module.<br>
!>  Alternatively, a description of these simulation specifications is always printed out the in `_report.txt` files of each ParaMonte DRAM-MCMC simulation.
!>
!>  \note
!>  The contents of this module are not meant to be used by the end users of the ParaMonte library.<br>
!>
!>  \devnote
!>  The madness seen here with module-level generics is due to the lack of support for PDTs in \gfortran{13.1} and older versions.<br>
!>
!>  \finmain
!>
!>  \author
!>  \AmirShahmoradi, Monday 00:01 AM, January 1, 2018, Institute for Computational Engineering and Sciences, University of Texas Austin

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    use pm_except, only: isNAN
    use pm_except, only: setNAN
    use pm_val2str, only: getStr
    use pm_arrayResize, only: setResized
    use pm_kind, only: SKC => SK, SK, IK, LK
    use pm_sampling_mcmc, only: specmcmc_type, astatmcmc_type, burninLoc_type, NL2, NL1
    use pm_sampling_scio, only: cfcdram_type

    implicit none

    character(*,SKC)        , parameter     :: MODULE_NAME = SK_"@pm_sampling_dram"

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ! simulation declarations.
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    type, abstract, extends(astatmcmc_type) :: astatdram_type
        type(burninLoc_type)                :: burninLocDRAM
        integer(IK)                         :: numFunCallAcceptedRejectedDelayed = 0_IK
        integer(IK)                         :: numFunCallAcceptedRejectedDelayedUnused = 0_IK
    end type

    type, extends(astatdram_type)           :: statdram_type
        type(cfcdram_type)                  :: cfc
    end type

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ! specification declarations.
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   !real(RKC)                               :: burninAdaptationMeasure ! namelist input
    type                                    :: burninAdaptationMeasure_type
        real(RKC)                           :: val
        real(RKC)                           :: def
        character(:,SKC)    , allocatable   :: desc
    end type

   !integer(IK)                             :: proposalAdaptationCount ! namelist input
    type                                    :: proposalAdaptationCount_type
        integer(IK)                         :: val
        integer(IK)                         :: def
        integer(IK)                         :: null
        character(:,SKC)    , allocatable   :: desc
    end type

   !integer(IK)                             :: proposalAdaptationCountGreedy ! namelist input
    type                                    :: proposalAdaptationCountGreedy_type
        integer(IK)                         :: val
        integer(IK)                         :: def
        integer(IK)                         :: null
        character(:,SKC)    , allocatable   :: desc
    end type

   !integer(IK)                             :: proposalAdaptationPeriod ! namelist input
    type                                    :: proposalAdaptationPeriod_type
        integer(IK)                         :: val
        integer(IK)                         :: def
        integer(IK)                         :: null
        character(:,SKC)    , allocatable   :: desc
    end type

   !integer(IK)                             :: proposalDelayedRejectionCount ! namelist input
    type                                    :: proposalDelayedRejectionCount_type
        integer(IK)                         :: max = 1000_IK
        integer(IK)                         :: min = 0_IK
        integer(IK)                         :: val
        integer(IK)                         :: def
        integer(IK)                         :: null
        character(:,SKC)    , allocatable   :: desc
    end type

   !real(RKC)               , allocatable   :: proposalDelayedRejectionScaleFactor(:) ! namelist input
    type                                    :: proposalDelayedRejectionScaleFactor_type
        real(RKC)                           :: def
        real(RKC)           , allocatable   :: val(:)
       !real(RKC)           , allocatable   :: log(:)
        character(:,SKC)    , allocatable   :: desc
    end type

    type, extends(specmcmc_type)                        :: specdram_type
        type(burninAdaptationMeasure_type)              :: burninAdaptationMeasure
        type(proposalAdaptationCount_type)              :: proposalAdaptationCount
        type(proposalAdaptationCountGreedy_type)        :: proposalAdaptationCountGreedy
        type(proposalAdaptationPeriod_type)             :: proposalAdaptationPeriod
        type(proposalDelayedRejectionCount_type)        :: proposalDelayedRejectionCount
        type(proposalDelayedRejectionScaleFactor_type)  :: proposalDelayedRejectionScaleFactor
    contains
        procedure, pass, private                        :: sanitize
        procedure, pass, private                        :: report
        procedure, pass, public                         :: set
    end type

    interface specdram_type
        module procedure :: construct
    end interface

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

contains

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    subroutine killMeAlreadyCMake1_RK5(); use pm_sampling_scio_RK5, only: RKC; end subroutine
    subroutine killMeAlreadyCMake1_RK4(); use pm_sampling_scio_RK4, only: RKC; end subroutine
    subroutine killMeAlreadyCMake1_RK3(); use pm_sampling_scio_RK3, only: RKC; end subroutine
    subroutine killMeAlreadyCMake1_RK2(); use pm_sampling_scio_RK2, only: RKC; end subroutine
    subroutine killMeAlreadyCMake1_RK1(); use pm_sampling_scio_RK1, only: RKC; end subroutine

    subroutine killMeAlreadyCMake2_RK5(); use pm_sampling_mcmc_RK5, only: RKC; end subroutine
    subroutine killMeAlreadyCMake2_RK4(); use pm_sampling_mcmc_RK4, only: RKC; end subroutine
    subroutine killMeAlreadyCMake2_RK3(); use pm_sampling_mcmc_RK3, only: RKC; end subroutine
    subroutine killMeAlreadyCMake2_RK2(); use pm_sampling_mcmc_RK2, only: RKC; end subroutine
    subroutine killMeAlreadyCMake2_RK1(); use pm_sampling_mcmc_RK1, only: RKC; end subroutine

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function construct(modelr, method, ndim) result(spec)
#if __INTEL_COMPILER && DLL_ENABLED && (_WIN32 || _WIN64)
        !DEC$ ATTRIBUTES DLLEXPORT :: construct
#endif
        use pm_kind, only: modelr_type
        type(modelr_type), intent(in) :: modelr
        character(*,SKC), intent(in) :: method
        integer(IK), intent(in) :: ndim
        type(specdram_type) :: spec

        spec%specmcmc_type = specmcmc_type(modelr, method, ndim)

        burninAdaptationMeasure_block: block
            use pm_sampling_scio, only: burninAdaptationMeasure
            spec%burninAdaptationMeasure%def = 1._RKC
            spec%burninAdaptationMeasure%desc = &
            SKC_"The simulation specification `burninAdaptationMeasure` is a scalar of type `real` of the highest precision available &
                &within the ParaMonte library whose value, between 0 and 1, represents the adaptation measure threshold below which &
                &the simulated Markov chain will be used to generate the output sample. In other words, any point in the output Markov &
                &chain that has been sampled during significant adaptation of the proposal distribution (set by `burninAdaptationMeasure`) &
                &will not be included in the construction of the final MCMC output sample. &
                &This is to ensure that the generation of the output sample will be based only on the part of the simulated chain that &
                &is practically guaranteed to be Markovian and ergodic. If this variable is set to 0, then the output sample will be &
                &generated from the part of the chain where no proposal adaptation has occurred. This non-adaptive or minimally-adaptive &
                &part of the chain may not even exist if the total adaptation period of the simulation, set by `proposalAdaptationCount` &
                &and `proposalAdaptationPeriod` input variables, is longer than the total length of the output MCMC chain. &
                &In such cases, the resulting output sample may have a zero size. In general, when good mixing occurs &
                &(e.g., when the input variable `outputChainSize` is reasonably large), then any specific &
                &value of `burninAdaptationMeasure` becomes practically irrelevant. &
                &The default value for `burninAdaptationMeasure` is "//getStr(spec%burninAdaptationMeasure%def)//SKC_", implying that the &
                &entire chain (excluding of an initial automatically-determined burnin period) will be used to generate the final output sample."
            !$omp master
            call setNAN(burninAdaptationMeasure)
            !$omp end master
        end block burninAdaptationMeasure_block

        proposalAdaptationCount_block: block
            use pm_sampling_scio, only: proposalAdaptationCount
            spec%proposalAdaptationCount%null = -huge(0_IK)
            spec%proposalAdaptationCount%def  = huge(0_IK)
            spec%proposalAdaptationCount%desc = &
            SKC_"The simulation specification `proposalAdaptationCount` is a scalar of type `integer` representing the total number of &
                &adaptive updates that will be made to the parameters of the proposal distribution to increase the efficiency of the sampler &
                &thus increasing the overall sampling efficiency of the simulation. Every `proposalAdaptationPeriod` number of calls to the &
                &objective function, the parameters of the proposal distribution will be updated until either the total number of adaptive &
                &updates reaches the value of `proposalAdaptationCount`. This variable must be a non-negative integer. As a rule of thumb, &
                &it may be appropriate to ensure the condition `outputChainSize >> proposalAdaptationPeriod * proposalAdaptationCount` &
                &holds to improve the ergodicity and stationarity of the MCMC sampler. If `proposalAdaptationCount = 0`, &
                &then the proposal distribution parameters will be fixed to the initial input values &
                &throughout the entire MCMC sampling. The default value is "//getStr(spec%proposalAdaptationCount%def)//SKC_"."
            !$omp master
            proposalAdaptationCount = spec%proposalAdaptationCount%null
            !$omp end master
        end block proposalAdaptationCount_block

        proposalAdaptationCountGreedy_block: block
            use pm_sampling_scio, only: proposalAdaptationCountGreedy
            spec%proposalAdaptationCountGreedy%null = -huge(0_IK)
            spec%proposalAdaptationCountGreedy%def = 0_IK
            spec%proposalAdaptationCountGreedy%desc = &
            SKC_"The simulation specification `proposalAdaptationCountGreedy` is a positive-valued scalar of type `integer` representing the &
                &count of initial ""greedy"" adaptive updates the sampler will apply to the proposal distribution before starting regular adaptation. &
                &Greedy adaptations are made using only the 'unique' accepted points in the MCMC chain. This is useful, for example, when the function &
                &to be sampled by the sampler is high dimensional, in which case, the adaptive updates to proposal distribution will less likely lead to &
                &numerical instabilities, for example, a singular covariance matrix for the multivariate proposal sampler. &
                &The variable `proposalAdaptationCountGreedy` must be less than the specified value for `proposalAdaptationCount`. &
                &If it is larger, it will be automatically reset to `proposalAdaptationCount` for the simulation. &
                &The default value is "//getStr(spec%proposalAdaptationCountGreedy%def)//SKC_"."
            !$omp master
            proposalAdaptationCountGreedy = spec%proposalAdaptationCountGreedy%null
            !$omp end master
        end block proposalAdaptationCountGreedy_block

        proposalAdaptationPeriod_block: block
            use pm_sampling_scio, only: proposalAdaptationPeriod
            spec%proposalAdaptationPeriod%def = spec%ndim%val * 4_IK !+ 1_IK ! max(ndim+1_IK,100_IK)
            spec%proposalAdaptationPeriod%null = -huge(0_IK)
            spec%proposalAdaptationPeriod%desc = &
            SKC_"The simulation specification `proposalAdaptationPeriod` is a positive-valued scalar of type `integer`. &
                &Every `proposalAdaptationPeriod` calls to the objective function, the parameters of the proposal distribution will be updated. &
                &The smaller the value of `proposalAdaptationPeriod`, the easier it will be for the sampler kernel to adapt the proposal distribution &
                &to the covariance structure of the objective function. However, this will happen at the expense of slower simulation runtime as the &
                &adaptation process can become computationally expensive, in particular, for very high dimensional objective functions (ndim >> 1). &
                &The larger the value of `proposalAdaptationPeriod`, the easier it will be for the sampler kernel to keep the sampling efficiency &
                &close to the requested target acceptance rate range (if specified via the input variable targetAcceptanceRate). However, too large &
                &values for `proposalAdaptationPeriod` will only delay the adaptation of the proposal distribution to the global structure of &
                &the objective function that is being sampled. If the condition `proposalAdaptationPeriod >= outputChainSize` holds, then no &
                &adaptive updates to the proposal distribution will be made. The default value is `4 * ndim`, where `ndim` is the dimension &
                &of the domain of the objective function to be sampled."
            !$omp master
            proposalAdaptationPeriod = spec%proposalAdaptationPeriod%null
            !$omp end master
        end block proposalAdaptationPeriod_block

        proposalDelayedRejectionCount_block: block
            use pm_sampling_scio, only: proposalDelayedRejectionCount
            spec%proposalDelayedRejectionCount%null = -huge(0_IK)
            spec%proposalDelayedRejectionCount%def = 0_IK
            spec%proposalDelayedRejectionCount%desc = &
            SKC_"The simulation specification `proposalAdaptationPeriod` is a non-negative-valued scalar of type `integer` representing &
                &the total number of stages for which rejections of new proposals will be tolerated by MCMC sampler before going back &
                &to the previously accepted point (state). The condition `"//&
                getStr(spec%proposalDelayedRejectionCount%min)//" <= proposalDelayedRejectionCount <= "//getStr(spec%proposalDelayedRejectionCount%max)//&
            SKC_"` must hold. Possible values are:"//NL2//&
            SKC_"    proposalDelayedRejectionCount = 0"//NL2//&
            SKC_"            indicating no deployment of the delayed rejection algorithm."//NL2//&
            SKC_"    proposalDelayedRejectionCount > 0"//NL2//&
            SKC_"            which implies a maximum proposalDelayedRejectionCount number of rejections will be tolerated."//NL2//&
            SKC_"For example, `proposalDelayedRejectionCount = 1`, means that at any point during the sampling, if a proposal is rejected, &
                &the MCMC sampler will not go back to the last sampled state. Instead, it will continue to propose a new state from the last &
                &rejected proposal. If the new state is again rejected based on the rules of the MCMC sampler, then the algorithm will not &
                &tolerate further rejections, because the maximum number of rejections to be tolerated has been set by the user to be &
                &`proposalDelayedRejectionCount = 1`. The algorithm then goes back to the original last-accepted state and will begin &
                &proposing new states from that location. The default value is "// getStr(spec%proposalDelayedRejectionCount%def)//SKC_"."
            !$omp master
            proposalDelayedRejectionCount = spec%proposalDelayedRejectionCount%null
            !$omp end master
        end block proposalDelayedRejectionCount_block

        proposalDelayedRejectionScaleFactor_block: block
            use pm_sampling_scio, only: proposalDelayedRejectionScaleFactor
            spec%proposalDelayedRejectionScaleFactor%def  = 0.5_RKC**(1._RKC / spec%ndim%val) ! This gives a half volume to the covariance.
            spec%proposalDelayedRejectionScaleFactor%desc = &
            "The simulation specification `proposalDelayedRejectionScaleFactor` is a positive-valued vector of type `real` of the &
            &highest precision available within the ParaMonte library, of length `(1 : proposalDelayedRejectionCount)`, by which &
            &the covariance matrix of the proposal distribution of MCMC sampler is scaled when the Delayed Rejection (DR) scheme &
            &is activated (by setting `proposalDelayedRejectionCount > 0`). At each `i`th stage of the DR process, the proposal &
            &distribution from the last stage is scaled by the factor `proposalDelayedRejectionScaleFactor(i)`. &
            &Missing elements of the `proposalDelayedRejectionScaleFactor` in the input external file to the sampler will be set to &
            &the default value. The default value at all stages is `0.5**(1 / ndim)` where `ndim` is the number of dimensions of the &
            &domain of the objective function. This default value effectively reduces the volume of the covariance matrix &
            &of the proposal distribution by half compared to the last DR stage."
            !$omp master
            call setResized(proposalDelayedRejectionScaleFactor, spec%proposalDelayedRejectionCount%max)
            call setNAN(proposalDelayedRejectionScaleFactor)
            !$omp end master
        end block proposalDelayedRejectionScaleFactor_block

        !$omp barrier

    end function construct

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function set(spec, sampler) result(err)
#if __INTEL_COMPILER && DLL_ENABLED && (_WIN32 || _WIN64)
        !DEC$ ATTRIBUTES DLLEXPORT :: set
#endif
        use pm_err, only: err_type
        use pm_sampling, only: paradram_type
        use pm_sampling, only: sampler_type
        class(specdram_type), intent(inout) :: spec
        class(sampler_type), intent(in), optional :: sampler
        type(err_type) :: err

        select type(sampler)
        type is (paradram_type)

            err = spec%specmcmc_type%set(sampler%paramcmc_type)
            if (err%occurred) return

            burninAdaptationMeasure_block: block
                use pm_sampling_scio, only: burninAdaptationMeasure
                if (spec%overridable .and. allocated(sampler%burninAdaptationMeasure)) then
                    spec%burninAdaptationMeasure%val = real(sampler%burninAdaptationMeasure, RKC)
                else
                    spec%burninAdaptationMeasure%val = burninAdaptationMeasure
                end if
                if (isNAN(spec%burninAdaptationMeasure%val)) spec%burninAdaptationMeasure%val = spec%burninAdaptationMeasure%def
            end block burninAdaptationMeasure_block

            proposalAdaptationCount_block: block
                use pm_sampling_scio, only: proposalAdaptationCount
                if (spec%overridable .and. allocated(sampler%proposalAdaptationCount)) then
                    spec%proposalAdaptationCount%val = sampler%proposalAdaptationCount
                else
                    spec%proposalAdaptationCount%val = proposalAdaptationCount
                end if
                if (spec%proposalAdaptationCount%val == spec%proposalAdaptationCount%null) spec%proposalAdaptationCount%val = spec%proposalAdaptationCount%def
            end block proposalAdaptationCount_block

            proposalAdaptationCountGreedy_block: block
                use pm_sampling_scio, only: proposalAdaptationCountGreedy
                if (spec%overridable .and. allocated(sampler%proposalAdaptationCountGreedy)) then
                    spec%proposalAdaptationCountGreedy%val = sampler%proposalAdaptationCountGreedy
                else
                    spec%proposalAdaptationCountGreedy%val = proposalAdaptationCountGreedy
                end if
                if (spec%proposalAdaptationCountGreedy%val == spec%proposalAdaptationCountGreedy%null) spec%proposalAdaptationCountGreedy%val = spec%proposalAdaptationCountGreedy%def
            end block proposalAdaptationCountGreedy_block

            proposalAdaptationPeriod_block: block
                use pm_sampling_scio, only: proposalAdaptationPeriod
                if (spec%overridable .and. allocated(sampler%proposalAdaptationPeriod)) then
                    spec%proposalAdaptationPeriod%val = sampler%proposalAdaptationPeriod
                else
                    spec%proposalAdaptationPeriod%val = proposalAdaptationPeriod
                end if
                if (spec%proposalAdaptationPeriod%val == spec%proposalAdaptationPeriod%null) spec%proposalAdaptationPeriod%val = spec%proposalAdaptationPeriod%def
            end block proposalAdaptationPeriod_block

            proposalDelayedRejectionCount_block: block
                use pm_sampling_scio, only: proposalDelayedRejectionCount
                if (spec%overridable .and. allocated(sampler%proposalDelayedRejectionCount)) then
                    spec%proposalDelayedRejectionCount%val = sampler%proposalDelayedRejectionCount
                else
                    spec%proposalDelayedRejectionCount%val = proposalDelayedRejectionCount
                end if
                if (spec%proposalDelayedRejectionCount%val == spec%proposalDelayedRejectionCount%null) spec%proposalDelayedRejectionCount%val = spec%proposalDelayedRejectionCount%def
           end block proposalDelayedRejectionCount_block

            proposalDelayedRejectionScaleFactor_block: block
                use pm_sampling_scio, only: proposalDelayedRejectionScaleFactor
                use pm_arrayFill, only: getFilled
                integer(IK) :: idel
                if (spec%overridable .and. allocated(sampler%proposalDelayedRejectionScaleFactor)) then
                    spec%proposalDelayedRejectionScaleFactor%val = real(sampler%proposalDelayedRejectionScaleFactor, RKC)
                else
                    do idel = size(proposalDelayedRejectionScaleFactor, 1, IK), 1, -1
                        if (.not. isNAN(proposalDelayedRejectionScaleFactor(idel))) exit
                    end do
                    spec%proposalDelayedRejectionScaleFactor%val = proposalDelayedRejectionScaleFactor(1 : idel)
                end if
                if (0_IK < size(spec%proposalDelayedRejectionScaleFactor%val, 1, IK)) then
                    where (isNAN(spec%proposalDelayedRejectionScaleFactor%val))
                        spec%proposalDelayedRejectionScaleFactor%val = spec%proposalDelayedRejectionScaleFactor%def
                    end where
                elseif (0_IK < spec%proposalDelayedRejectionCount%val) then
                    spec%proposalDelayedRejectionScaleFactor%val = getFilled(spec%proposalDelayedRejectionScaleFactor%def, spec%proposalDelayedRejectionCount%val)
                else
                    call setResized(spec%proposalDelayedRejectionScaleFactor%val, 0_IK)
                end if
            end block proposalDelayedRejectionScaleFactor_block

            ! Take care of exceptional cases.

            block
                integer(IK) :: idel, remaining
                remaining = spec%proposalDelayedRejectionCount%val - size(spec%proposalDelayedRejectionScaleFactor%val, 1, IK)
                if (0_IK < remaining) then
                    spec%proposalDelayedRejectionScaleFactor%val = [spec%proposalDelayedRejectionScaleFactor%val, (spec%proposalDelayedRejectionScaleFactor%def, idel = 1, remaining)]
                end if
            end block

            ! open output files, report and sanitize.

            if (spec%image%is%leader) call spec%report() ! if (spec%run%is%new)
            call spec%sanitize(err)

        class default
            error stop "The input `sampler` must be of type `paradram_type`." ! LCOV_EXCL_LINE
        end select

    end function

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    subroutine report(spec)
#if __INTEL_COMPILER && DLL_ENABLED && (_WIN32 || _WIN64)
        !DEC$ ATTRIBUTES DLLEXPORT :: report
#endif
        use pm_str, only: UNDEFINED
        class(specdram_type), intent(inout) :: spec

        call spec%disp%text%wrap(NL1//spec%method%val//SKC_".simulation.specifications.dram"//NL1)

        associate(ndim => spec%ndim%val, format => spec%reportFile%format%generic)

            call spec%disp%show("burninAdaptationMeasure")
            call spec%disp%show(spec%burninAdaptationMeasure%val, format = format)
            call spec%disp%note%show(spec%burninAdaptationMeasure%desc)

            call spec%disp%show("proposalAdaptationCount")
            call spec%disp%show(spec%proposalAdaptationCount%val, format = format)
            call spec%disp%note%show(spec%proposalAdaptationCount%desc)

            call spec%disp%show("proposalAdaptationCountGreedy")
            call spec%disp%show(spec%proposalAdaptationCountGreedy%val, format = format)
            call spec%disp%note%show(spec%proposalAdaptationCountGreedy%desc)

            call spec%disp%show("proposalAdaptationPeriod")
            call spec%disp%show(spec%proposalAdaptationPeriod%val, format = format)
            call spec%disp%note%show(spec%proposalAdaptationPeriod%desc)

            call spec%disp%show("proposalDelayedRejectionCount")
            call spec%disp%show(spec%proposalDelayedRejectionCount%val, format = format)
            call spec%disp%note%show(spec%proposalDelayedRejectionCount%desc)

            call spec%disp%show("proposalDelayedRejectionScaleFactor")
            if (size(spec%proposalDelayedRejectionScaleFactor%val) == 0) then
                call spec%disp%show(UNDEFINED, format = format)
            else
                call spec%disp%show(reshape(spec%proposalDelayedRejectionScaleFactor%val, [size(spec%proposalDelayedRejectionScaleFactor%val), 1]), format = format)
            end if
            call spec%disp%note%show(spec%proposalDelayedRejectionScaleFactor%desc)

        end associate

    end subroutine

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    subroutine sanitize(spec, err)
#if __INTEL_COMPILER && DLL_ENABLED && (_WIN32 || _WIN64)
        !DEC$ ATTRIBUTES DLLEXPORT :: sanitize
#endif
        use pm_err, only: err_type, getFine
        type(err_type), intent(inout) :: err
        class(specdram_type), intent(inout) :: spec
        character(*,SKC), parameter :: PROCEDURE_NAME = MODULE_NAME//SKC_"@sanitizeSpecDRAM()"

        burninAdaptationMeasure_block: block
            if (spec%burninAdaptationMeasure%val < 0._RKC) then
                err%occurred = .true._LK
                err%msg =   err%msg//NL2//PROCEDURE_NAME//getFine(__FILE__, __LINE__)//SKC_": Error occurred. &
                            &The input specification `burninAdaptationMeasure` ("//getStr(spec%burninAdaptationMeasure%val)//SKC_") cannot be less than 0. &
                            &If you are unsure of the appropriate value for burninAdaptationMeasure, drop it from the input list. &
                            &The sampler will automatically assign an appropriate value to it."
            end if
            if (1._RKC < spec%burninAdaptationMeasure%val) then
                err%occurred = .true._LK
                err%msg =   err%msg//NL2//PROCEDURE_NAME//getFine(__FILE__, __LINE__)//SKC_": Error occurred. &
                            &The input specification `burninAdaptationMeasure` ("//getStr(spec%burninAdaptationMeasure%val)//SKC_") cannot be larger than 1. &
                            &If you are unsure of the appropriate value for burninAdaptationMeasure, drop it from the input list. &
                            &The sampler will automatically assign an appropriate value to it."
            end if
        end block burninAdaptationMeasure_block

        proposalAdaptationCount_block: block
            if (spec%proposalAdaptationCount%val < 0_IK) then
                err%occurred = .true._LK
                err%msg =   err%msg//NL2//PROCEDURE_NAME//SKC_"@sanitize(): Error occurred. &
                            &The input requested value for `proposalAdaptationCount` ("//getStr(spec%proposalAdaptationCount%val)//SKC_") &
                            &cannot be negative. If you are unsure of the appropriate value for `proposalAdaptationCount`, drop it from &
                            &the input list. The sampler will automatically assign an appropriate value to it."
            end if
        end block proposalAdaptationCount_block

        proposalAdaptationCountGreedy_block: block
            if (spec%proposalAdaptationCountGreedy%val < 0_IK) then
                err%occurred = .true._LK
                err%msg =   err%msg//NL2//MODULE_NAME//SKC_"@sanitize(): Error occurred. &
                            &The input requested value for `proposalAdaptationCountGreedy` ("//getStr(spec%proposalAdaptationCountGreedy%val)//SKC_") cannot be negative. &
                            &If you are unsure of the appropriate value for `proposalAdaptationCountGreedy`, drop it from the input list. &
                            &The sampler will automatically assign an appropriate value to it."
            end if
        end block proposalAdaptationCountGreedy_block

        proposalAdaptationPeriod_block: block
            if (spec%proposalAdaptationPeriod%val < 1_IK) then
                err%occurred = .true._LK
                err%msg =   err%msg//NL2//MODULE_NAME//SKC_"@sanitize(): Error occurred. &
                            &The input requested value for `proposalAdaptationPeriod` ("//getStr(spec%proposalAdaptationPeriod%val)//SKC_") cannot be less than 1. &
                            &If you are unsure of the appropriate value for proposalAdaptationPeriod, drop it from the input list. &
                            &The sampler will automatically assign an appropriate value to it."
            end if
        end block proposalAdaptationPeriod_block

        proposalDelayedRejectionCount_block: block
            if (spec%proposalDelayedRejectionCount%val < spec%proposalDelayedRejectionCount%min) then
                err%occurred = .true._LK
                err%msg =   err%msg//NL2//PROCEDURE_NAME//getFine(__FILE__, __LINE__)//SKC_": Error occurred. &
                            &The input requested value for `proposalDelayedRejectionCount` ("//getStr(spec%proposalDelayedRejectionCount%val)//"SKC_) cannot be negative. &
                            &If you are unsure of the appropriate value for `proposalDelayedRejectionCount`, drop it from the input list. &
                            &The MCMC sampler will automatically assign an appropriate value to it."
            elseif (spec%proposalDelayedRejectionCount%val > spec%proposalDelayedRejectionCount%max) then
                err%occurred = .true._LK ! LCOV_EXCL_LINE
                err%msg =   err%msg//NL2//PROCEDURE_NAME//getFine(__FILE__, __LINE__)//SKC_": Error occurred. &
                            &The input requested value for `proposalDelayedRejectionCount` ("//getStr(spec%proposalDelayedRejectionCount%val)//SKC_") can not be > "// &
                            getStr(spec%proposalDelayedRejectionCount%max)//SKC_". If you are unsure of the appropriate value for &
                            &`proposalDelayedRejectionCount`, drop it from the input list. The MCMC sampler will &
                            &automatically assign an appropriate value to it."
            end if
        end block proposalDelayedRejectionCount_block

        proposalDelayedRejectionScaleFactor_block: block
            use pm_sampling_scio, only: proposalDelayedRejectionScaleFactor
            integer(IK) :: idel
            if (size(spec%proposalDelayedRejectionScaleFactor%val, 1, IK) /= spec%proposalDelayedRejectionCount%val) then
                err%occurred = .true._LK
                err%msg =   err%msg//NL2//PROCEDURE_NAME//getFine(__FILE__, __LINE__)//SKC_": Error occurred. The length of the vector `proposalDelayedRejectionScaleFactor` ("//&
                            getStr(size(spec%proposalDelayedRejectionScaleFactor%val))//SKC_") is not equal to proposalDelayedRejectionCount = "//&
                            getStr(spec%proposalDelayedRejectionCount%val)//SKC_". If you are unsure how to set the values of `proposalDelayedRejectionScaleFactor`, &
                            &drop it from the input. The sampler will automatically set the appropriate value for `proposalDelayedRejectionScaleFactor`."
            end if
            do idel = 1, size(spec%proposalDelayedRejectionScaleFactor%val, 1, IK)
                if (spec%proposalDelayedRejectionScaleFactor%val(idel) <= 0._RKC) then
                !    spec%proposalDelayedRejectionScaleFactor%log(idel) = log(spec%proposalDelayedRejectionScaleFactor%val(idel))
                !else
                    err%occurred = .true._LK
                    err%msg =   err%msg//NL2//PROCEDURE_NAME//getFine(__FILE__, __LINE__)//SKC_": Error occurred. The input value for the element `"//getStr(idel)//&
                                SKC_"` of the variable proposalDelayedRejectionScaleFactor cannot be smaller than or equal to 0."
                end if
            end do
            !$omp barrier
            !$omp master
            if (allocated(proposalDelayedRejectionScaleFactor)) deallocate(proposalDelayedRejectionScaleFactor)
            !$omp end master
        end block proposalDelayedRejectionScaleFactor_block

    end subroutine

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
