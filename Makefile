dir = test_dir
malicious_dir = quarantine
interval_secs = 5


pre_build:
		@mkdir -p "$(malicious_dir)"


antivirus: pre_build
		@./antivirusd.sh "$(dir)" "$(malicious_dir)" "$(interval_secs)"


restore: pre_build
		@./restore.sh "$(dir)" "$(malicious_dir)"
