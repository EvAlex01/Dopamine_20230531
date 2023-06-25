#import <libjailbreak/jailbreakd.h>
#import <libjailbreak/libjailbreak.h>

int reboot3(uint64_t flags, ...);
#define RB2_USERREBOOT (0x2000000000000000llu)
extern char **environ;

void print_usage(void)
{
	printf("Usage: jbctl <command> <arguments>\n\
Available commands:\n\
	proc_set_debugged <pid>\t\tMarks the process with the given pid as being debugged, allowing invalid code pages inside of it\n\
	rebuild_trustcache\t\tRebuilds the TrustCache, clearing any previously trustcached files that no longer exists from it (automatically ran daily at midnight)\n\
	update <tipa/basebin> <path>\tInitiates a jailbreak update either based on a TIPA or based on a basebin.tar file, TIPA installation depends on TrollStore, afterwards it triggers a userspace reboot\n\
	bindmount_path <source_path>\tFor a valid given source <source_path>, copy its contents and mount it onto `/var/jb/<source_path>`. This could be used to modify system files.\n\
	bindunmount_path <source_path>\tThis reverts what `bindmount_path` does.\n");
}

int main(int argc, char* argv[])
{
	setvbuf(stdout, NULL, _IOLBF, 0);
	if (argc < 2) {
		print_usage();
		return 1;
	}

	char *cmd = argv[1];
	if (!strcmp(cmd, "proc_set_debugged")) {
		if (argc != 3) {
			print_usage();
			return 1;
		}
		int pid = atoi(argv[2]);
		int64_t result = jbdProcSetDebugged(pid);
		if (result == 0) {
			printf("Successfully marked proc of pid %d as debugged\n", pid);
		}
		else {
			printf("Failed to mark proc of pid %d as debugged\n", pid);
		}
	}
	else if (!strcmp(cmd, "rebuild_trustcache")) {
		jbdRebuildTrustCache();
	} else if (!strcmp(cmd, "update")) {
		if (argc < 4) {
			print_usage();
			return 2;
		}
		char *updateType = argv[2];
		int64_t result = -1;
		if (!strcmp(updateType, "tipa")) {
			result = jbdUpdateFromTIPA([NSString stringWithUTF8String:argv[3]], false);
		} else if(!strcmp(updateType, "basebin")) {
			result = jbdUpdateFromBasebinTar([NSString stringWithUTF8String:argv[3]], false);
		}
		if (result == 0) {
			printf("Update applied, userspace rebooting to finalize it...\n");
			sleep(2);
			return reboot3(RB2_USERREBOOT);
			// execve(prebootPath(@"usr/bin/launchctl").fileSystemRepresentation, (char *const[]){ (char *const)prebootPath(@"usr/bin/launchctl").fileSystemRepresentation, "reboot", "userspace", NULL }, environ);
			// return 0;
		}
		else {
			printf("Update failed with error code %lld\n", result);
			return result;
		}
	} else if (!strcmp(cmd, "userspace_reboot")) {
		execve(prebootPath(@"usr/bin/launchctl").fileSystemRepresentation,
			(char *const[]){
				(char *const)prebootPath(@"usr/bin/launchctl").fileSystemRepresentation, "reboot", "userspace", NULL
			}, environ);
	} else if (!strcmp(cmd, "bindmount_path")) {
		if (argc != 3) {
			return 1;
		} else {
			jbdBindMountPath([NSString stringWithUTF8String:argv[2]], true);
		}
	} else if (!strcmp(cmd, "bindunmount_path")) {
		if (argc != 3) {
			return 1;
		} else {
			jbdBindUnmountPath([NSString stringWithUTF8String:argv[2]]);
		}
	}

	return 0;
}
