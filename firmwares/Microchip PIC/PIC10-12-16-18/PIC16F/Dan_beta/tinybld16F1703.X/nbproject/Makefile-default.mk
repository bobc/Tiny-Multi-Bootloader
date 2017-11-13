#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=cof
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/tinybld16F1703.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/tinybld16F1703.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=tinybld16F1703_16MHz_int_9600bd.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o
POSSIBLE_DEPFILES=${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o

# Source Files
SOURCEFILES=tinybld16F1703_16MHz_int_9600bd.asm


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
	${MAKE} ${MAKE_OPTIONS} -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/tinybld16F1703.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=16f1703
MP_LINKER_DEBUG_OPTION= 
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o: tinybld16F1703_16MHz_int_9600bd.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o.d 
	@${RM} ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o 
	@${FIXDEPS} dummy.d -e "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd.ERR" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  $(ASM_OPTIONS)   \"C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd.asm\" 
	@${MV}  "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd".O ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o
	@${MV}  "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd".ERR ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o.err
	@${MV}  "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd".LST ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o.lst
	@${RM}  "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd".HEX 
	@${DEP_GEN} -d "${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o"
	@${FIXDEPS} "${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o: tinybld16F1703_16MHz_int_9600bd.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	@${RM} ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o.d 
	@${RM} ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o 
	@${FIXDEPS} dummy.d -e "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd.ERR" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  $(ASM_OPTIONS)   \"C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd.asm\" 
	@${MV}  "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd".O ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o
	@${MV}  "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd".ERR ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o.err
	@${MV}  "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd".LST ${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o.lst
	@${RM}  "C:/Documents and Settings/Administrator/MPLABXProjects/tinybld16F1703.X/tinybld16F1703_16MHz_int_9600bd".HEX 
	@${DEP_GEN} -d "${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o"
	@${FIXDEPS} "${OBJECTDIR}/tinybld16F1703_16MHz_int_9600bd.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/tinybld16F1703.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w -x -u_DEBUG -z__ICD2RAM=1 -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -z__MPLAB_DEBUG=1 -z__MPLAB_DEBUGGER_ICD3=1 $(MP_LINKER_DEBUG_OPTION) -odist/${CND_CONF}/${IMAGE_TYPE}/tinybld16F1703.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/tinybld16F1703.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w  -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -odist/${CND_CONF}/${IMAGE_TYPE}/tinybld16F1703.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
