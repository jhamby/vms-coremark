# Copyright 2018 Embedded Microprocessor Benchmark Consortium (EEMBC)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# Original Author: Shay Gal-on

# Make sure the default target is to simply build and run the benchmark.
RSTAMP = v1.0

.ifndef ITERATIONS
ITERATIONS=0
.endif
.ifdef REBUILD
FORCE_REBUILD=force_rebuild
.endif

CFLAGS = /Def=(ITERATIONS=$(ITERATIONS),posix,PERFORMANCE_RUN=1,FLAGS_STR="""""")/Inc=([],[.posix])
CFLAGS = $(CFLAGS)/Poi=Long=Argv
CFLAGS = $(CFLAGS)/Opt=Lev=5
OEXT = .OBJ
EXE = .EXE

CORE_FILES = core_list_join core_main core_matrix core_state core_util [.posix]core_portme
ORIG_SRCS = $(addsuffix .c,$(CORE_FILES))
SRC_PLUS_LIST = core_list_join.c+core_main.c+core_matrix.c+core_state.c+core_util.c+[.posix]core_portme.c
SRCS = $(ORIG_SRCS) $(PORT_SRCS)
OBJS = $(addprefix $(OPATH),$(addsuffix $(OEXT),$(CORE_FILES)) $(PORT_OBJS))
OUTNAME = coremark$(EXE)
OUTFILE = $(OPATH)$(OUTNAME)
LOUTCMD = $(OFLAG) $(OUTFILE) $(LFLAGS_END)
OUTCMD = $(OUTFLAG) $(OUTFILE) $(LFLAGS_END)

HEADERS = coremark.h 
CHECK_FILES = $(ORIG_SRCS) $(HEADERS)

$(OUTNAME) : $(ORIG_SRCS) $(HEADERS) 
	$(CC) $(CFLAGS) /Obj=coremark.obj /PLUS_LIST $(SRC_PLUS_LIST)
	$(LINK) /Exec=$(OUTNAME) coremark.obj

run : $(OUTFILE) #rerun score

score :
	@ write sys$output "Check run1.log and run2.log for results."
	@ write sys$output "See README.md for run and reporting rules." 

#rerun :
#	$(MAKE) XCFLAGS="$(XCFLAGS) -DPERFORMANCE_RUN=1" load run1.log
#	$(MAKE) XCFLAGS="$(XCFLAGS) -DVALIDATION_RUN=1" load run2.log

PARAM1 := $(PORT_PARAMS) 0x0 0x0 0x66 $(ITERATIONS)
PARAM2 := $(PORT_PARAMS) 0x3415 0x3415 0x66 $(ITERATIONS)
PARAM3 := $(PORT_PARAMS) 8 8 8 $(ITERATIONS)

run1.log-PARAM := $(PARAM1) 7 1 2000
run2.log-PARAM := $(PARAM2) 7 1 2000 
run3.log-PARAM := $(PARAM3) 7 1 1200

#run1.log run2.log run3.log : load
#	$(MAKE) port_prerun
#	$(RUN) $(OUTFILE) $($(@)-PARAM) > $(OPATH)$@
#	$(MAKE) port_postrun
	
#load : $(OUTFILE)
#	$(MAKE) port_preload
#	$(LOAD) $(OUTFILE)
#	$(MAKE) port_postload

clean :
	Del/Log $(OUTFILE);*,*.obj;*,*.log;*
