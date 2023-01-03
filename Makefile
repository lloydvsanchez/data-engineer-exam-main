default:
	@echo "If you're able to read this, then make is working in your system. \n\
	Now, unto the next step, refer to README.md \n\\n\
	Note: please update 'env' file to set access_keys"

extract:
	ruby ./extract.rb

transform:
	ruby ./transform.rb

load:
	ruby ./load.rb
