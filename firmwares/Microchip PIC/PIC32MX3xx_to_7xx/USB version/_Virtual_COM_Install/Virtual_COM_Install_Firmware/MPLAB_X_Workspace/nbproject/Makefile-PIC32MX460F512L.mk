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
ifeq "$(wildcard nbproject/Makefile-local-PIC32MX460F512L.mk)" "nbproject/Makefile-local-PIC32MX460F512L.mk"
include nbproject/Makefile-local-PIC32MX460F512L.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=PIC32MX460F512L
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/MPLAB_X_Workspace.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/MPLAB_X_Workspace.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED="C:/Program Files/Microchip/Microchip Solutions/Microchip/USB/usb_device.c" "C:/Program Files/Microchip/Microchip Solutions/Microchip/USB/CDC Device Driver/usb_function_cdc.c" ../source/main.c ../source/usb_descriptors.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/592283297/usb_device.o ${OBJECTDIR}/_ext/796499546/usb_function_cdc.o ${OBJECTDIR}/_ext/812168374/main.o ${OBJECTDIR}/_ext/812168374/usb_descriptors.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/592283297/usb_device.o.d ${OBJECTDIR}/_ext/796499546/usb_function_cdc.o.d ${OBJECTDIR}/_ext/812168374/main.o.d ${OBJECTDIR}/_ext/812168374/usb_descriptors.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/592283297/usb_device.o ${OBJECTDIR}/_ext/796499546/usb_function_cdc.o ${OBJECTDIR}/_ext/812168374/main.o ${OBJECTDIR}/_ext/812168374/usb_descriptors.o

# Source Files
SOURCEFILES=C:/Program Files/Microchip/Microchip Solutions/Microchip/USB/usb_device.c C:/Program Files/Microchip/Microchip Solutions/Microchip/USB/CDC Device Driver/usb_function_cdc.c ../source/main.c ../source/usb_descriptors.c


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
	${MAKE} ${MAKE_OPTIONS} -f nbproject/Makefile-PIC32MX460F512L.mk dist/${CND_CONF}/${IMAGE_TYPE}/MPLAB_X_Workspace.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=32MX460F512L
MP_LINKER_FILE_OPTION=
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/592283297/usb_device.o: C:/Program\ Files/Microchip/Microchip\ Solutions/Microchip/USB/usb_device.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/592283297 
	@${RM} ${OBJECTDIR}/_ext/592283297/usb_device.o.d 
	@${RM} ${OBJECTDIR}/_ext/592283297/usb_device.o 
	@${FIXDEPS} "${OBJECTDIR}/_ext/592283297/usb_device.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1  -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include" -I"../source" -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include/Usb" -MMD -MF "${OBJECTDIR}/_ext/592283297/usb_device.o.d" -o ${OBJECTDIR}/_ext/592283297/usb_device.o "C:/Program Files/Microchip/Microchip Solutions/Microchip/USB/usb_device.c"  
	
${OBJECTDIR}/_ext/796499546/usb_function_cdc.o: C:/Program\ Files/Microchip/Microchip\ Solutions/Microchip/USB/CDC\ Device\ Driver/usb_function_cdc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/796499546 
	@${RM} ${OBJECTDIR}/_ext/796499546/usb_function_cdc.o.d 
	@${RM} ${OBJECTDIR}/_ext/796499546/usb_function_cdc.o 
	@${FIXDEPS} "${OBJECTDIR}/_ext/796499546/usb_function_cdc.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1  -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include" -I"../source" -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include/Usb" -MMD -MF "${OBJECTDIR}/_ext/796499546/usb_function_cdc.o.d" -o ${OBJECTDIR}/_ext/796499546/usb_function_cdc.o "C:/Program Files/Microchip/Microchip Solutions/Microchip/USB/CDC Device Driver/usb_function_cdc.c"  
	
${OBJECTDIR}/_ext/812168374/main.o: ../source/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/main.o 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/main.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1  -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include" -I"../source" -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include/Usb" -MMD -MF "${OBJECTDIR}/_ext/812168374/main.o.d" -o ${OBJECTDIR}/_ext/812168374/main.o ../source/main.c  
	
${OBJECTDIR}/_ext/812168374/usb_descriptors.o: ../source/usb_descriptors.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/usb_descriptors.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/usb_descriptors.o 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/usb_descriptors.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c ${MP_CC} $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_PK3=1  -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include" -I"../source" -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include/Usb" -MMD -MF "${OBJECTDIR}/_ext/812168374/usb_descriptors.o.d" -o ${OBJECTDIR}/_ext/812168374/usb_descriptors.o ../source/usb_descriptors.c  
	
else
${OBJECTDIR}/_ext/592283297/usb_device.o: C:/Program\ Files/Microchip/Microchip\ Solutions/Microchip/USB/usb_device.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/592283297 
	@${RM} ${OBJECTDIR}/_ext/592283297/usb_device.o.d 
	@${RM} ${OBJECTDIR}/_ext/592283297/usb_device.o 
	@${FIXDEPS} "${OBJECTDIR}/_ext/592283297/usb_device.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include" -I"../source" -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include/Usb" -MMD -MF "${OBJECTDIR}/_ext/592283297/usb_device.o.d" -o ${OBJECTDIR}/_ext/592283297/usb_device.o "C:/Program Files/Microchip/Microchip Solutions/Microchip/USB/usb_device.c"  
	
${OBJECTDIR}/_ext/796499546/usb_function_cdc.o: C:/Program\ Files/Microchip/Microchip\ Solutions/Microchip/USB/CDC\ Device\ Driver/usb_function_cdc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/796499546 
	@${RM} ${OBJECTDIR}/_ext/796499546/usb_function_cdc.o.d 
	@${RM} ${OBJECTDIR}/_ext/796499546/usb_function_cdc.o 
	@${FIXDEPS} "${OBJECTDIR}/_ext/796499546/usb_function_cdc.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include" -I"../source" -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include/Usb" -MMD -MF "${OBJECTDIR}/_ext/796499546/usb_function_cdc.o.d" -o ${OBJECTDIR}/_ext/796499546/usb_function_cdc.o "C:/Program Files/Microchip/Microchip Solutions/Microchip/USB/CDC Device Driver/usb_function_cdc.c"  
	
${OBJECTDIR}/_ext/812168374/main.o: ../source/main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/main.o 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/main.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include" -I"../source" -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include/Usb" -MMD -MF "${OBJECTDIR}/_ext/812168374/main.o.d" -o ${OBJECTDIR}/_ext/812168374/main.o ../source/main.c  
	
${OBJECTDIR}/_ext/812168374/usb_descriptors.o: ../source/usb_descriptors.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/812168374 
	@${RM} ${OBJECTDIR}/_ext/812168374/usb_descriptors.o.d 
	@${RM} ${OBJECTDIR}/_ext/812168374/usb_descriptors.o 
	@${FIXDEPS} "${OBJECTDIR}/_ext/812168374/usb_descriptors.o.d" $(SILENT) -rsi ${MP_CC_DIR}../ -c ${MP_CC} $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include" -I"../source" -I"C:/Program Files/Microchip/Microchip Solutions/Microchip/Include/Usb" -MMD -MF "${OBJECTDIR}/_ext/812168374/usb_descriptors.o.d" -o ${OBJECTDIR}/_ext/812168374/usb_descriptors.o ../source/usb_descriptors.c  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/MPLAB_X_Workspace.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -mdebugger -D__MPLAB_DEBUGGER_PK3=1 -mprocessor=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/MPLAB_X_Workspace.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}       -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_PK3=1,-L"C:/Program Files/Microchip/MPLAB C32/lib",-L"C:/Program Files/Microchip/MPLAB C32/pic32mx/lib",-Map="${DISTDIR}/MPLAB_X_Workspace.${IMAGE_TYPE}.map" 
else
dist/${CND_CONF}/${IMAGE_TYPE}/MPLAB_X_Workspace.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -mprocessor=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/MPLAB_X_Workspace.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}       -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),-L"C:/Program Files/Microchip/MPLAB C32/lib",-L"C:/Program Files/Microchip/MPLAB C32/pic32mx/lib",-Map="${DISTDIR}/MPLAB_X_Workspace.${IMAGE_TYPE}.map"
	${MP_CC_DIR}\\pic32-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/MPLAB_X_Workspace.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/PIC32MX460F512L
	${RM} -r dist/PIC32MX460F512L

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
