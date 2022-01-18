" Vim syntax file
" Language:	HTCondor submit description file
" Maintainer:	GullumLuvl
" Last Change:	2022-01-18

" Usage
"
" copy to $HOME/.vim/syntax directory and add:
"
" au BufNewFile,BufRead *.condor set syntax=Condor
" au BufNewFile,BufRead *.condor.txt set syntax=Condor
"
" to your $HOME/.vimrc file
"
" force coloring in a vim session with:
"
" :set syntax=Condor
"

" load settings from system python.vim (7.4)
"source $VIMRUNTIME/syntax/python.vim

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "Condor"

" vim:set sw=2 sts=2 ts=8 noet:

" condor_submit syntax:

syn region condorComment start='#' skip='#' end='$' contains=condorTodo oneline keepend
syn keyword condorTodo TODO TOREDO FIXME XXX contained
syn case ignore  "case-insensitive keywords.

syn cluster Left contains=condorCommand,condorSpecialCommand
syn cluster Right contains=condorString,condorBool,condorInteger,condorMacro,condorSubstMacro,condorMacroFunction
syn cluster Variables contains=condorInteger,condorAutoVariable,condorCommand

syn match condorAssign '=' display
syn region condorAssigned	oneline matchgroup=condorAssign start='=' end='\ze\($\|#\)' keepend contains=@Right nextgroup=condorComment skipwhite

syn match condorBool '\<True\>\|\<False\>' contained display
syn match condorInteger '\<\d\+\>' contained
"syn match condorBytes '\<\d\(M\|G\)\>'
syntax region condorString start=+"+ end=+"+ skip=+\\"\|""+ contained contains=condorMacroFunction,condorSubstMacro,condorMacro

"MACROS AND COMMENTS
syn region condorMacro matchgroup=condorMacroLim start='\$(' end=')' contained contains=@Variables display
"evaluated on the host machine:
syn region condorSubstMacro matchgroup=condorMacroLim start='\$\$(' end=')' contained display
syn case match
syn region condorMacroFunction matchgroup=condorMacroLim start='\$\(INT\|REAL\|ENV\|DIRNAME\|BASENAME\|RANDOM_INTEGER\|CHOICE\|SUBSTR\|F[fpduwnxbqa]\+\)(' end=')' contained contains=@Variables ",condorMacroContent
syn match condorMacroLim '.*' contained
syn case ignore
"syn match condorMacroContent '.*' contained  "I'd like this to not be highlighted

"Automatic Submit variables
"Post-parsing:
syn keyword condorAutoVariable ClusterId Cluster ProcId Process Node Step ItemIndex Row Item contained
"Pre-parsing:
syn keyword condorAutoVariable ARCH OPSYS OPSYSANDVER OPSYSMAJORVER OPSYSVER SPOOL IsLinux IsWindows contained

syn match condorIncludeOperator ':' display
syn keyword condorIncludeCommand	include nextgroup=condorIncludeOperator skipwhite


" anything before an equal sign:
syn match condorAnyCommand	'^\s*\zs\([^#\t ]\+\)\ze\s*=' contains=@Left nextgroup=condorAssigned skipwhite
syn keyword condorCommand	arguments error executable getenv log notification notify_user output priority request_cpus request_disk request_memory requirements contained
syn keyword condorCommand	environment input log_xml universe rank contained
"FILE TRANSFER COMMANDS
syn keyword condorCommand dont_encrypt_input_files dont_encrypt_output_files encrypt_execute_directory encrypt_input_files encrypt_output_files max_transfer_input_mb max_transfer_output_mb output_destination should_transfer_files skip_filechecks stream_error stream_input stream_output transfer_executable transfer_input_files transfer_output_files transfer_output_remaps when_to_transfer_output contained
"POLICY COMMANDS
syn keyword condorCommand max_retries retry_until success_exit_code hold keep_claim_idle leave_in_queue next_job_start_delay on_exit_hold on_exit_hold_reason on_exit_hold_subcode on_exit_remove periodic_hold periodic_hold_reason periodic_hold_subcode periodic_release periodic_remove contained
"COMMANDS SPECIFIC TO THE STANDARD UNIVERSE
syn keyword condorCommand allow_startup_script append_files buffer_files buffer_size buffer_block_size compress_files fetch_files file_remaps local_files want_remote_io contained
"COMMANDS FOR THE GRID
syn keyword condorCommand batch_queue boinc_authenticator_file cream_attributes delegate_job_GSI_credentials_lifetime ec2_access_key_id ec2_ami_id ec2_availability_zone ec2_block_device_mapping ec2_ebs_volumes ec2_elastic_ip ec2_iam_profile_arn ec2_iam_profile_name ec2_instance_type ec2_keypair ec2_keypair_file ec2_parameter_names ec2_secret_access_key ec2_security_groups ec2_security_ids ec2_spot_price ec2_tag_names WantNameTag ec2_user_data ec2_user_data_file ec2_vpc_ip ec2_vpc_subnet gce_auth_file gce_image gce_json_file gce_machine_type gce_metadata gce_metadata_file gce_preemptible globus_rematch globus_resubmit globus_rsl grid_resource keystore_alias keystore_file keystore_passphrase_file MyProxyCredentialName MyProxyHost MyProxyNewProxyLifetime MyProxyPassword MyProxyRefreshThreshold MyProxyServerDN nordugrid_rsl transfer_error transfer_input transfer_output use_x509userproxy x509userproxy contained
"COMMANDS FOR PARALLEL, JAVA, and SCHEDULER UNIVERSES
syn keyword condorCommand hold_kill_sig jar_files java_vm_args machine_count remove_kill_sig remove_kill_sig remove_kill_sig contained
"COMMANDS FOR THE VM UNIVERSE
syn keyword condorCommand vm_disk vm_disk vm_checkpoint vm_macaddr vm_memory vm_networking vm_networking_type vm_no_output_vm vm_type vmware_dir vmware_should_transfer_files vmware_snapshot_disk xen_initrd xen_kernel xen_kernel_params xen_root contained
"COMMANDS FOR THE DOCKER UNIVERSE
syn keyword condorCommand docker_image contained
"ADVANCED COMMANDS
syn keyword condorCommand accounting_group accounting_group_user concurrency_limits concurrency_limits_expr copy_to_spool coresize cron_day_of_month cron_day_of_week cron_hour cron_minute cron_month cron_prep_time cron_window dagman_log deferral_prep_time deferral_time deferral_window description email_attributes image_size initialdir job_ad_information_attrs JobBatchName job_lease_duration job_machine_attrs want_graceful_removal kill_sig kill_sig_timeout load_profile match_list_length LastMatchName0 LastMatchName1 job_max_vacate_time max_job_retirement_time nice_user niceuser noop_job noop_job_exit_code noop_job_exit_signal remote_initialdir rendezvousdir run_as_owner stack_size submit_event_notes contained
syn cluster Left add=condorCommand

"Attributes into the job ClassAd
" +<attribute> = <value>
"PRE AND POST SCRIPTS IMPLEMENTED WITH SPECIALLY-NAMED ATTRIBUTES
" should be followed by double-quoted elements.
syn match condorSpecialCommand '+\(PreCmd\|PreArgs\|PreArguments\|PreEnv\|PreEnvironment\|PostCmd\|PostArgs\|PostArguments\|PostEnv\|PostEnvironment\)\>' contained display

"QUEUE COMMANDS
syn cluster Queued contains=condorQueueOperator,condorQueueIntExpr,condorQueueVarname,condorQueueShellOperator,condorDelimiter,condorQueueItemList
syn cluster condorQueueOperator contains=condorQueueListOperator,condorQueueGlobOperator

syn region condorQueueExpr matchgroup=condorQueueCommand start='Queue' end='$' contains=@Queued skipnl
syn match condorQueueIntExpr 'Queue\s\+\zs\d\+' contained display
"syn match condorQueueVarname '' contained
"syn match condorQueueListOfVarnames '' contained
"syn match condorQueueListOfVarnames '' contained
"syn match condorQueueFilesDirs '' contained
syn region condorQueueItemList start='(' end=')' contained extend
syn match condorQueueSlice '[\(\d+\)\?:\(\d\+\)\?\(:\(\d+\)\?)\?]' contained
"syn match condorQueueListOfItems
syn match condorQueueGlobOperator '\<matching\>\(\s\+\<\(files\|dirs\)\>\)\?' nextgroup=condorQueueFilesDirs skipwhite
syn keyword condorQueueListOperator in from nextgroup=condorQueueItemList skipwhite
"nextgroup=condorQueueFilesDirs
syn keyword condorQueueCommand	Queue nextgroup=condorQueueExpr skipwhite
syn match condorShellOperator	'|\s\+$' extend display
syn match condorDelimiter ','  contained display "contained in queue expressions

syn keyword condorConditional if else endif
syn region condorConditionalBlock matchgroup=condorConditional start='if' end='endif'
"syn case match  "turn back on case-sensitive matching.

hi def link condorComment Comment
hi def link condorTodo aTodo

hi def link condorAssign Operator

"hi def link condorBool Boolean  " it's kinda too much to highlight those,
"except in the QueueExpressions maybe
"hi def link condorInteger Number
hi def link condorString String

"hi def link condorMacro Identifier
"hi def link condorSubstMacro Identifier
"hi def link condorMacroFunction Identifier
hi def link condorMacroLim Identifier  " Delimiter would be more semantically correct
hi def link condorAutoVariable Identifier

hi def link condorAnyCommand Underlined
hi def link condorCommand Function
hi def link condorSpecialCommand Function
hi def link condorIncludeCommand Include

hi def link condorQueueCommand Macro
hi def link condorQueueListOperator Operator
hi def link condorQueueGlobOperator Operator
hi def link condorQueueIntExpr Number
hi def link condorDelimiter Delimiter

hi def link condorConditional Conditional

"TODO: hi def link condorBadArguments Error

"List of language elements:
":help group-name
