//
//  DataModel.h
//  GeneralFramework
//
//  Created by ZMJ on 15/4/19.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//

#import "BaseModel.h"
@protocol DataModel                 @end
@protocol ParentModel                 @end
@protocol BannerViewModel                 @end
@protocol ArticleViewModel                 @end
@protocol VersionModel                 @end
@protocol UserViewModel                 @end
@protocol ProjectViewModel                 @end
@protocol UserCenterInfoViewModel                 @end
@protocol EnvelopeViewModel                 @end
@protocol CreditorViewModel                 @end
@protocol CarManagerMentViewModel                 @end
@protocol InvestViewModel                 @end
@protocol InvestRepayRoadmapViewModel                 @end
@protocol InterestCompleteViewModel                 @end
@protocol FreeViewModel                 @end
@protocol ProjectRightsViewModel                 @end
@protocol AuthenticationViewModel                 @end
@protocol ReferrerViewModel                 @end
@protocol AboutViewModel                 @end
@protocol AutomaticallySaveViewModel                 @end
@protocol TransactViewModel                 @end
@protocol IntegralViewModel                 @end
@protocol JpushViewModel                 @end
@protocol ConditionViewModel                 @end
@protocol ConditionViewModels                 @end
@protocol BorrowedPlanViewModel                 @end
@protocol NowProjectDetailViewModel                 @end
@protocol TransferRepayViewModel                 @end
@protocol BankViewModel                 @end
@protocol RankViewModel                 @end
@protocol CalendarMonthViewModel                 @end
@protocol CalendarMonthDetailViewModel                 @end
@protocol ExtenViewModel                 @end
@class DataModel,ParentModel,BannerViewModel,ArticleViewModel,VersionModel,UserViewModel,ProjectViewModel,UserCenterInfoViewModel,EnvelopeViewModel,CreditorViewModel,CarManagerMentViewModel,InvestViewModel,InvestRepayRoadmapViewModel,InterestCompleteViewModel,FreeViewModel,ProjectRightsViewModel,AuthenticationViewModel,ReferrerViewModel,AboutViewModel,AutomaticallySaveViewModel,TransactViewModel,IntegralViewModel,JpushViewModel,ConditionViewModel,ConditionViewModels,BorrowedPlanViewModel,NowProjectDetailViewModel,TransferRepayViewModel,BankViewModel,RankViewModel,CalendarMonthViewModel,CalendarMonthDetailViewModel,ExtenViewModel;

@interface DataModel : BaseDataModel

@end
@interface ParentModel : BaseDataModel
@property (nonatomic, copy) NSString * autoInvest;
@property (nonatomic, copy) NSString * bindIP;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, copy) NSString * cashPassword;
@property (nonatomic, copy) NSString * channel;
@property (nonatomic, copy) NSString * comment;
@property (nonatomic, copy) NSString * couponActivityStatus;
@property (nonatomic, copy) NSString * currentAddress;
@property (nonatomic, copy) NSString * disableTime;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * homeAddress;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * idCard;
@property (nonatomic, copy) NSString * investAmount;
@property (nonatomic, copy) NSString * investAmountXS;
@property (nonatomic, copy) NSString * ip;
//@property (nonatomic, copy) NSString * lastLoginArea;
@property (nonatomic, copy) NSString * lastLoginTime;
@property (nonatomic, copy) NSString * mobileNumber;
@property (nonatomic, copy) NSString * msn;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * qq;
@property (nonatomic, copy) NSString * realname;
@property (nonatomic, copy) NSString * referrer;
@property (nonatomic, copy) NSString * registerTime;
@property (nonatomic, copy) NSString * securityAnswer1;
@property (nonatomic, copy) NSString * securityAnswer2;
@property (nonatomic, copy) NSString * securityQuestion1;
@property (nonatomic, copy) NSString * securityQuestion2;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * subst;
@property (nonatomic, copy) NSString * userLevel;
@property (nonatomic, copy) NSString * userPoint;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * acceleration;
@property (nonatomic, copy) NSString * withDrawFreeCount;
@property (nonatomic, copy) NSString * feeRateCut;
@end

@interface BannerViewModel: BaseDataModel
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * isOutSite;
@property (nonatomic, copy) NSString * picture;
@property (nonatomic, copy) NSString * seqNum;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * url;
@end

@interface ArticleViewModel: BaseDataModel
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * creator;
@property (nonatomic, copy) NSString * lastModifyUser;
@property (nonatomic, copy) NSString * nodeLink;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * updateTime;
@end

@interface VersionModel: BaseDataModel
@property (nonatomic, copy) NSString * version;
@property (nonatomic, copy) NSString * content;
@end

@interface UserViewModel: BaseDataModel
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * userId;
@end

@interface ProjectViewModel: BaseDataModel
@property (nonatomic, copy) NSString *actualRate;
@property (nonatomic, copy) NSString *applyCode;
@property (nonatomic, copy) NSString *assure;
@property (nonatomic, copy) NSString *biddingContent;
@property (nonatomic, copy) NSString *bondArea;
@property (nonatomic, copy) NSString *bondBusiMobile;
@property (nonatomic, copy) NSString *bondBusiName;
@property (nonatomic, copy) NSString *bondBusiSfz;
@property (nonatomic, copy) NSString *bondICP;
@property (nonatomic, copy) NSString *bondName;
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, copy) NSString *cancelTime;
@property (nonatomic, copy) NSString *cardinalNumber;
@property (nonatomic, copy) NSString *child;
@property (nonatomic, copy) NSString *childRecordNum;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *commitTime;
@property (nonatomic, copy) NSString *companyDescription;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyNo;
@property (nonatomic, copy) NSString *compensationUser;
@property (nonatomic, copy) NSString *completeTime;
@property (nonatomic, copy) NSString *contractType;
@property (nonatomic, copy) NSString *creditMobile;
@property (nonatomic, copy) NSString *creditSex;
@property (nonatomic, copy) NSString *custType;
@property (nonatomic, copy) NSString *customPicture;
@property (nonatomic, copy) NSString *cyunInvest;
@property (nonatomic, copy) NSString *deadline;
@property (nonatomic, copy) NSString *deposit;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *expectTime;
@property (nonatomic, copy) NSString *feeOnRepay;
@property (nonatomic, copy) NSString *fundDescription;
@property (nonatomic, copy) NSString *giveMoneyTime;
@property (nonatomic, copy) NSString *guaranteeCompanyDescription;
@property (nonatomic, copy) NSString *guaranteeCompanyName;
@property (nonatomic, copy) NSString *guaranteeInfoDescription;
@property (nonatomic, copy) NSString *hasPawn;
@property (nonatomic, copy) NSString *hdRate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *interestBeginTime;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *investPassword;
@property (nonatomic, copy) NSString *investorFeeRate;
@property (nonatomic, copy) NSString *jd;
@property (nonatomic, assign) CGFloat jkRate;
@property (nonatomic, copy) NSString *lastStrTime;
@property (nonatomic, copy) NSString *loanActivityType;
@property (nonatomic, copy) NSString *loanGuranteeFee;
@property (nonatomic, copy) NSString *loanInstruction;
@property (nonatomic, copy) NSString *loanMasterId;
@property (nonatomic, copy) NSString *loanMoney;
@property (nonatomic, copy) NSString *loanPurpose;
@property (nonatomic, copy) NSString *loanType;
@property (nonatomic, copy) NSString *loanerIdentify;
@property (nonatomic, copy) NSString *loanerName;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *maxInvestMoney;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *minInvestMoney;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *myRatePercent;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *otherContent;
@property (nonatomic, copy) NSString *overdueInfo;
@property (nonatomic, copy) NSString *pawn;
@property (nonatomic, copy) NSString *pawnName;
@property (nonatomic, copy) NSString *planStatus;
@property (nonatomic, copy) NSString *policyDescription;
@property (nonatomic, copy) NSString *proince;
@property (nonatomic, copy) NSString *projectSource;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *rateIBOI;
@property (nonatomic, copy) NSString *recordNum;
@property (nonatomic, copy) NSString *repayDay;
@property (nonatomic, copy) NSString *repayFinalTime;
@property (nonatomic, copy) NSString *repayPeriod;
@property (nonatomic, strong) InvestRepayRoadmapViewModel *repayRoadmap;
@property (nonatomic, copy) NSString *repaySource;
@property (nonatomic, copy) NSString *repayTimeUnit;
@property (nonatomic, copy) NSString *repayType;
@property (nonatomic, copy) NSString *repaymentType;
@property (nonatomic, copy) NSString *riskDescription;
@property (nonatomic, copy) NSString *riskInstruction;
@property (nonatomic, copy) NSString *riskLevel;
@property (nonatomic, copy) NSString *seqNum;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *sybj;
@property (nonatomic, copy) NSString *transferType;
@property (nonatomic, copy) NSString *verified;
@property (nonatomic, copy) NSString *verifyMessage;
@property (nonatomic, copy) NSString *verifyTime;
@property (nonatomic, copy) NSString *videoId;
@end


@interface UserCenterInfoViewModel: BaseDataModel
@property (nonatomic, copy) NSString *accumulativeInvestAmount;
@property (nonatomic, copy) NSString *balcance;
@property (nonatomic, copy) NSString *dsje;
@property (nonatomic, copy) NSString *earnedAmount;
@property (nonatomic, copy) NSString *frozen;
@property (nonatomic, copy) NSString *investAmount;
@property (nonatomic, copy) NSString *monthToReceiveAmount;
@property (nonatomic, copy) NSString *monthToRepayAmount;
@property (nonatomic, copy) NSString *myInvestsInterest;
@property (nonatomic, copy) NSString *mySum;
@property (nonatomic, copy) NSString *overdueAmount;
@property (nonatomic, copy) NSString *repayingInvestAmount;
@property (nonatomic, copy) NSString *toRepayAmount;
@property (nonatomic, copy) NSString *toRepayPieces;
@end

@interface EnvelopeViewModel: BaseDataModel
@property (nonatomic, copy) NSString *generateTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lowerLimitMoney;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *periodOfValidity;
@property (nonatomic, copy) NSString *startterm;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@end

@interface CreditorViewModel: BaseDataModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *investMoney;
@property (nonatomic, copy) NSString *investTime;
@property (nonatomic, copy) NSString *loanId;
@property (nonatomic, copy) NSString *loanName;
@property (nonatomic, copy) NSString *remainTime;
@property (nonatomic, copy) NSString *unPaidMoney;
/////可转出
@property (nonatomic, copy) NSString *debitWorth;
@property (nonatomic, copy) NSString *feeRate;
@property (nonatomic, copy) NSString *investId;

//已转出
@property (nonatomic, copy) NSString *applyTime;
@property (nonatomic, copy) NSString *deadline;
@property (nonatomic, copy) NSString *premium;
@property (nonatomic, copy) NSString *transferCorpus;
//转让中
@property (nonatomic, copy) NSString *transferWorth;
@property (nonatomic, copy) NSString *rate;

//已展期
@property (nonatomic, copy) NSString *extensionPeriod;
@property (nonatomic, copy) NSString *extensionRate;
@property (nonatomic, copy) NSString *extensionStatus;
@property (nonatomic, copy) NSString *investExtensionId;
@end


@interface CarManagerMentViewModel: BaseDataModel
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *bankArea;
@property (nonatomic, copy) NSString *bankCardType;
@property (nonatomic, copy) NSString *bankCity;
@property (nonatomic, copy) NSString *bankNo;
@property (nonatomic, copy) NSString *bankProvince;
@property (nonatomic, copy) NSString *bankServiceType;
@property (nonatomic, copy) NSString *bindingprice;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@end


@interface InvestViewModel: BaseDataModel
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userInvestPass;
@property (nonatomic, copy) NSString *comeFrom;
@property (nonatomic, copy) NSString *couponLoanNo;
@property (nonatomic, copy) NSString *couponMoney;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *investMoney;
@property (nonatomic, copy) NSString *isAutoInvest;
@property (nonatomic, copy) NSString *jd;
@property (nonatomic, copy) NSString *jdRate;
@property (nonatomic, copy) NSString *loanId;
@property (nonatomic, copy) NSString *loanName;
@property (nonatomic, copy) NSString *loanNo;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *ratePercent;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, strong) InvestRepayRoadmapViewModel *repayRoadmap;
@end


@interface InvestRepayRoadmapViewModel: BaseDataModel
@property (nonatomic, copy) NSString *feePlus;
@property (nonatomic, copy) NSString *nextRepayCorpus;
@property (nonatomic, copy) NSString *nextRepayDate;
@property (nonatomic, copy) NSString *nextRepayDefaultInterest;
@property (nonatomic, copy) NSString *nextRepayFee;
@property (nonatomic, copy) NSString *nextRepayInterest;
@property (nonatomic, copy) NSString *nextRepayMoney;
@property (nonatomic, copy) NSString *paidCorpus;
@property (nonatomic, copy) NSString *paidDefaultInterest;
@property (nonatomic, copy) NSString *paidFee;
@property (nonatomic, copy) NSString *paidInterest;
@property (nonatomic, copy) NSString *paidMoney;
@property (nonatomic, copy) NSString *paidPeriod;
@property (nonatomic, copy) NSString *repayCorpus;
@property (nonatomic, copy) NSString *repayDefaultInterest;
@property (nonatomic, copy) NSString *repayFee;
@property (nonatomic, copy) NSString *repayInterest;
@property (nonatomic, copy) NSString *repayMoney;
@property (nonatomic, copy) NSString *unPaidCorpus;
@property (nonatomic, copy) NSString *unPaidDefaultInterest;
@property (nonatomic, copy) NSString *unPaidFee;
@property (nonatomic, copy) NSString *unPaidInterest;
@property (nonatomic, copy) NSString *unPaidMoney;
@property (nonatomic, copy) NSString *unPaidPeriod;

@end


@interface InterestCompleteViewModel: BaseDataModel
@property (nonatomic, copy) NSString *corpus;//本金
@property (nonatomic, copy) NSString *corpusToSystem;
@property (nonatomic, copy) NSString *defaultInterest;//默认利息
@property (nonatomic, copy) NSString *fee;//费用
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *interest;//利息
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *period;//期数
@property (nonatomic, copy) NSString *repayDay;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;

@end

@interface FreeViewModel: BaseDataModel
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *money;
@end

@interface ProjectRightsViewModel: BaseDataModel
@property (nonatomic, copy) NSString *applyTime;
@property (nonatomic, copy) NSString *cardinalNumber;
@property (nonatomic, copy) NSString *corpus;
@property (nonatomic, copy) NSString *deadline;
@property (nonatomic, copy) NSString *debitWorth;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *loanId;
@property (nonatomic, copy) NSString *loanName;
@property (nonatomic, copy) NSString *minInvestMoney;
@property (nonatomic, copy) NSString *premium;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *progress;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *remainCorpus;
@property (nonatomic, copy) NSString *repayType;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *transferWorth;
@property (nonatomic, copy) NSString *unPaidPeriod;
@property (nonatomic, copy) NSString *unit;
@end


@interface AuthenticationViewModel: BaseDataModel
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *sex;
@end


@interface ReferrerViewModel: BaseDataModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *investor;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *repayRoadmap;
@property (nonatomic, copy) NSString *time;
@end

@interface AboutViewModel: BaseDataModel
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lastModifyUser;
@property (nonatomic, copy) NSString *nodeLink;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *updateTime;
@end

@interface AutomaticallySaveViewModel: BaseDataModel
@property (nonatomic, copy) NSString *investMoney;
@property (nonatomic, copy) NSString *lastAutoInvestTime;
@property (nonatomic, copy) NSString *maxDeadline;
@property (nonatomic, copy) NSString *maxRate;
@property (nonatomic, copy) NSString *maxRatePercent;
@property (nonatomic, copy) NSString *minDeadline;
@property (nonatomic, copy) NSString *minRate;
@property (nonatomic, copy) NSString *minRatePercent;
@property (nonatomic, copy) NSString *queueAmount;
@property (nonatomic, copy) NSString *queueOrder;
@property (nonatomic, copy) NSString *remainMoney;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
@end

@interface TransactViewModel: BaseDataModel
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *balanceStr;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *frozenMoney;
@property (nonatomic, copy) NSString *frozenMoneyStr;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *moneyStr;
@property (nonatomic, copy) NSString *seqNum;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeInfo;
@end


@interface IntegralViewModel: BaseDataModel
@property (nonatomic, copy) NSString *acceleration;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *feeRateCut;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *minPointLimit;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pointValue;
@property (nonatomic, copy) NSString *seqNum;
@property (nonatomic, copy) NSString *validityPeriod;
@property (nonatomic, copy) NSString *withDrawFreeCount;
@end


@interface JpushViewModel: BaseDataModel
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString *editTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *redactor;
@property (nonatomic, copy) NSString *requestData;
@property (nonatomic, copy) NSString *requestTime;
@property (nonatomic, copy) NSString *responseData;
@property (nonatomic, copy) NSString *responseTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *userList;
@end






@interface ConditionViewModel: BaseDataModel
@property (nonatomic, copy) NSString *comeFrom;
@property (nonatomic, copy) NSString *couponLoanNo;
@property (nonatomic, copy) NSString *couponMoney;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *investMoney;
@property (nonatomic, copy) NSString *isAutoInvest;
@property (nonatomic, copy) NSString *jd;
@property (nonatomic, copy) NSString *jdRate;
@property (nonatomic, copy) NSString *loanId;
@property (nonatomic, copy) NSString *loanName;
@property (nonatomic, copy) NSString *loanNo;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *ratePercent;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userInvestPass;
@property (nonatomic, strong) ConditionViewModels *repayRoadmap;
@end




@interface ConditionViewModels: BaseDataModel
@property (nonatomic, copy) NSString *feePlus;
@property (nonatomic, copy) NSString *nextRepayCorpus;
@property (nonatomic, copy) NSString *nextRepayDate;
@property (nonatomic, copy) NSString *nextRepayDefaultInterest;
@property (nonatomic, copy) NSString *nextRepayFee;
@property (nonatomic, copy) NSString *nextRepayInterest;
@property (nonatomic, copy) NSString *nextRepayMoney;
@property (nonatomic, copy) NSString *paidCorpus;
@property (nonatomic, copy) NSString *paidDefaultInterest;
@property (nonatomic, copy) NSString *paidFee;
@property (nonatomic, copy) NSString *paidInterest;
@property (nonatomic, copy) NSString *paidMoney;
@property (nonatomic, copy) NSString *paidPeriod;
@property (nonatomic, copy) NSString *repayCorpus;
@property (nonatomic, copy) NSString *repayDefaultInterest;
@property (nonatomic, copy) NSString *repayFee;
@property (nonatomic, copy) NSString *repayInterest;
@property (nonatomic, copy) NSString *repayMoney;
@property (nonatomic, copy) NSString *unPaidCorpus;
@property (nonatomic, copy) NSString *unPaidDefaultInterest;
@property (nonatomic, copy) NSString *unPaidFee;
@property (nonatomic, copy) NSString *unPaidInterest;
@property (nonatomic, copy) NSString *unPaidMoney;
@property (nonatomic, copy) NSString *unPaidPeriod;
@end




@interface BorrowedPlanViewModel: BaseDataModel
@property (nonatomic, copy) NSString *corpus;
@property (nonatomic, copy) NSString *defaultInterest;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *penalty;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *repayDay;
@property (nonatomic, copy) NSString *repayWay;
@property (nonatomic, copy) NSString *repaying;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@end


@interface NowProjectDetailViewModel: BaseDataModel
@property (nonatomic, copy) NSString *comeFrom;
@property (nonatomic, copy) NSString *couponLoanNo;
@property (nonatomic, copy) NSString *couponMoney;
@property (nonatomic, copy) NSString *cyunInvest;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *investMoney;
@property (nonatomic, copy) NSString *isAutoInvest;
@property (nonatomic, copy) NSString *loanNo;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *ratePercent;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *repayRoadmap;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userInvestPass;
@property (nonatomic, copy) NSString *userName;
@end


@interface TransferRepayViewModel: BaseDataModel
@property (nonatomic, copy) NSString *applyTime;
@property (nonatomic, copy) NSString *cardinalNumber;
@property (nonatomic, copy) NSString *corpus;
@property (nonatomic, copy) NSString *deadline;
@property (nonatomic, copy) NSString *debitWorth;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *loanId;
@property (nonatomic, copy) NSString *loanName;
@property (nonatomic, copy) NSString *minInvestMoney;
@property (nonatomic, copy) NSString *premium;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *progress;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *remainCorpus;
@property (nonatomic, copy) NSString *repayType;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *transferWorth;
@property (nonatomic, copy) NSString *unPaidPeriod;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *loanMasterId;
@end


@interface BankViewModel: BaseDataModel
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *investByMonth;
@property (nonatomic, copy) NSString *investByYear;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
@end


/**
 当前排名
 */
@interface RankViewModel: BaseDataModel
@property (nonatomic, copy) NSString *investor;
@end


@interface CalendarMonthViewModel: BaseDataModel
@property (nonatomic, copy) NSString *counts;
@property (nonatomic, copy) NSString *repayDate;
@property (nonatomic, copy) NSString *sumMoney;
@end

@interface CalendarMonthDetailViewModel: BaseDataModel
@property (nonatomic, copy) NSString *corpus;
@property (nonatomic, copy) NSString *corpusToSystem;
@property (nonatomic, copy) NSString *defaultInterest;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *loanName;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *repayDay;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@end

@interface ExtenViewModel: BaseDataModel
@property (nonatomic, copy) NSString *corpus;
@property (nonatomic, copy) NSString *extensionPeriod;
@property (nonatomic, copy) NSString *extensionRate;
@property (nonatomic, copy) NSString *free;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *investExtensionId;
@property (nonatomic, copy) NSString *investId;
@property (nonatomic, copy) NSString *investMoney;
@property (nonatomic, copy) NSString *investTime;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *loanExtensionId;
@property (nonatomic, copy) NSString *loanId;
@property (nonatomic, copy) NSString *loanName;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *repayDay;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@end
