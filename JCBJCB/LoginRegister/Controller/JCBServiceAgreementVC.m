//
//  JCBServiceAgreementVC.m
//  JCBJCB
//
//  Created by apple on 16/11/24.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBServiceAgreementVC.h"

@interface JCBServiceAgreementVC ()
@property (nonatomic, strong) UIScrollView *bgScrollView;
@end

@implementation JCBServiceAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务协议";
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationButtonReturn" highImage:nil];
    [self setupSubviews];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupSubviews {
    
    self.bgScrollView = [[UIScrollView alloc] init];
    CGFloat bgScrollViewX = 0;
    CGFloat bgScrollViewY = navigationAndStatusBarHeight + SGMargin;
    CGFloat bgScrollViewW = SG_screenWidth;
    CGFloat bgScrollViewH = SG_screenHeight - SGMargin - navigationAndStatusBarHeight;
    _bgScrollView.frame = CGRectMake(bgScrollViewX, bgScrollViewY, bgScrollViewW, bgScrollViewH);
    _bgScrollView.backgroundColor = SGColorWithWhite;
    [self.view addSubview:_bgScrollView];
    
    
    UILabel *topTitle = [[UILabel alloc] init];
    NSString *topTitleStr = @"乐商贷注册协议";
    topTitle.text = topTitleStr;
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.font = [UIFont boldSystemFontOfSize:16];
    topTitle.numberOfLines = 0;
    // 计算内容的size
    CGSize topTitleSize = [SGHelperTool SG_sizeWithText:topTitleStr font:[UIFont boldSystemFontOfSize:15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    topTitle.frame = CGRectMake(SGMargin, 2 * SGMargin, SG_screenWidth - 2 * SGMargin, topTitleSize.height);
    [_bgScrollView addSubview:topTitle];

    UILabel *topContent = [[UILabel alloc] init];
    NSString *topContentStr = @"由温州乐商投资有限公司运营的乐商贷网站（网址：www.yueshanggroup.cn，包括以APP形式提供的操作环境，以下统称“乐商贷”），依据本协议的规定为金储蓄宝用户（以下简称用户）提供服务。在注册成为乐商贷用户前，请仔细阅读并完全理解本服务条款的全部内容，与您的权益有或可能具有重大关系，及对本公司具有或可能具有免责或限制责任的条款，请您特别注意。您一旦注册，则表示同意接受乐商贷的服务并接受以下条款的约束;若您不接受以下条款，请您立即停止注册或停止使用乐商贷提供的服务。";
    topContent.text = topContentStr;
    topContent.textColor = SGColorWithBlackOfDark;
    topContent.font = [UIFont systemFontOfSize:SGTextFontWith13];
    topContent.numberOfLines = 0;
    // 计算内容的size
    CGSize topContentSize = [SGHelperTool SG_sizeWithText:topContentStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    topContent.frame = CGRectMake(SGMargin, CGRectGetMaxY(topTitle.frame) + 2 * SGMargin, SG_screenWidth - 2 * SGMargin, topContentSize.height);
    [_bgScrollView addSubview:topContent];
    
#pragma mark - - - 协议一
    UILabel *titleOne = [[UILabel alloc] init];
    NSString *titleOneStr = @"第一条 本协议的签署和修订";
    titleOne.text = titleOneStr;
    titleOne.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleOne.numberOfLines = 0;
    // 计算内容的size
    CGSize titleOneSize = [SGHelperTool SG_sizeWithText:titleOneStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleOne.frame = CGRectMake(SGMargin, CGRectGetMaxY(topContent.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleOneSize.height);
    [_bgScrollView addSubview:titleOne];
    
    UILabel *contentOne = [[UILabel alloc] init];
    NSString *contentOneStr = @"1.1. 乐商贷只接受符合中华人民共和国法律（不包括香港特别行政区、澳门特别行政区和台湾地区的法律法规）规定的具有完全民事权利能力和民事行为能力，能独立行使和承担本规则项下权利义务的主体注册。若您不符合乐商贷注册资格，请勿注册，若您违反前述注册资格限制条件的，乐商贷有权随时终止您的用户资格，停止为您提供任何服务，您应对您的注册给本网站带来的损失承担全额赔偿责任，且您的监护人（如您为限制民事行为能力的自然人）应承担连带责任。\n\n1.2. 本协议内容包括以下条款及乐商贷发布的各类规则。所有规则为本协议不可分割的一部分，与协议正文具有同等法律效力。本协议是您与乐商贷共同签订的，适用于您在乐商贷的全部活动。在您注册成为用户时，您已经阅读、理解并接受本协议的全部条款及各类规则，并承诺遵守国家的各项法律法规，如有违反而导致任何法律后果，您将独立承担所有相应的法律责任。\n\n1.3. 乐商贷有权根据需要修改本协议或根据本协议制定、修改各类具体规则并在乐商贷相关系统板块发布，无需另行单独通知您。您应随时注意本协议及具体规则的变更，若您在本协议及具体规则内容公告变更后继续使用乐商贷服务的，表示您已接受修改后的协议和具体规则内容，同时就您在协议和具体规则修订前通过乐商贷进行的交易及其效力，视为您已同意并已按照本协议及有关具体规则进行了相应的授权和追认；若您不同意修改后的协议内容，您应停止使用乐商贷提供的服务。\n\n1.4. 您通过乐商贷有关规则、说明操作确认后，本协议即在您和乐商贷之间产生法律效力。本协议不涉及您与乐商贷的其他用户之间因线上交易而产生的法律关系或法律纠纷。";
    contentOne.text = contentOneStr;
    contentOne.textColor = SGColorWithBlackOfDark;
    contentOne.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentOne.numberOfLines = 0;
    // 计算内容的size
    CGSize contentOneSize = [SGHelperTool SG_sizeWithText:contentOneStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentOne.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleOne.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentOneSize.height);
    [_bgScrollView addSubview:contentOne];
    
#pragma mark - - - 协议二
    UILabel *titleTwo = [[UILabel alloc] init];
    NSString *titleTwoStr = @"第二条 技术的提供";
    titleTwo.text = titleTwoStr;
    titleTwo.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleTwo.numberOfLines = 0;
    // 计算内容的size
    CGSize titleTwoSize = [SGHelperTool SG_sizeWithText:titleTwoStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleTwo.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentOne.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleTwoSize.height);
    [_bgScrollView addSubview:titleTwo];
    
    UILabel *contentTwo = [[UILabel alloc] init];
    NSString *contentTwoStr = @"2.1. 乐商贷专注于为有投资需求的用户和有资金需求的融资人搭建一个安全、透明、便捷的网络交易平台，竭诚为注册用户提供投资咨询、财务规划、投资管理等咨询服务。您可以通过登录乐商贷进行资金充值、投资（出借）、签订合同、交易记录及收益查阅、提现、密码重置以及参加乐商贷的有关活动等，具体以乐商贷公布的服务内容为准。提供的服务包括但不限于：查阅交易记录、签订和查阅合同等，具体以乐商贷可提供的服务内容为准。\n\n2.2. 基于运行和交易安全的需要，乐商贷可以暂时停止提供、限制、改变或新增乐商贷提供的部分服务及功能。在任何功能减少、增加或者变化时，只要您仍然使用乐商贷的服务，表示您仍然同意本协议或者变更后的协议。\n\n2.3. 您确认，您在乐商贷上按乐商贷技术流程所确认的交易状态将成为乐商贷在您的授权下进行相关交易或操作的明确指令。您同意乐商贷有权按相关指令依据本协议和/或有关文件和规则对相关事项进行处理。\n\n2.4. 您未能及时对交易状态进行修改、确认或未能提交相关申请所引起的任何纠纷、损失由您本人负责，乐商贷不承担任何责任。\n\n2.5 乐商贷提供给您的服务是不可转让且非独占性的。用户不得转载、发布、销售，电子邮件或以其他任何形式将乐商贷的内容或服务转移到第三方。";
    contentTwo.text = contentTwoStr;
    contentTwo.textColor = SGColorWithBlackOfDark;
    contentTwo.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentTwo.numberOfLines = 0;
    // 计算内容的size
    CGSize contentTwoSize = [SGHelperTool SG_sizeWithText:contentTwoStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentTwo.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleTwo.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentTwoSize.height);
    [_bgScrollView addSubview:contentTwo];
    
#pragma mark - - - 协议三
    UILabel *titleThree = [[UILabel alloc] init];
    NSString *titleThreeStr = @"第三条 交易管理及费用";
    titleThree.text = titleThreeStr;
    titleThree.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleThree.numberOfLines = 0;
    // 计算内容的size
    CGSize titleThreeSize = [SGHelperTool SG_sizeWithText:titleThreeStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleThree.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentTwo.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleThreeSize.height);
    [_bgScrollView addSubview:titleThree];
    
    UILabel *contentThree = [[UILabel alloc] init];
    NSString *contentThreeStr = @"3.1. 在您成功注册后，您可以根据乐商贷有关规则和说明，经乐商公司关联方审核通过后签署有关协议，实现资金的出借（出借方式包括但不限于向借款人直接出借或受让债权等形式）。详细操作规则及方式请见有关协议及乐商贷相关页面的规则和说明。\n\n3.2. 乐商贷将为您资金的出借、回款等提供技术服务，并在提供服务过程中根据有关文件、协议和/或乐商贷页面的相关规则、说明等收取必要的服务费，其具体内容、比例、金额等事项请参见有关文件及乐商贷相关页面的规则和说明（包括但不限于，就您每一笔成功转让的债权，乐商贷有权基于您所转让债权的金额向您收取一定比例的转让管理费等款项作为服务费，具体比例及金额等请参见乐商贷的债权转让相关规则和说明）。您同意，乐商贷有权调整前述技术或管理费用的类型或金额等具体事项并根据本协议和相关规则进行公告、修改。";
    contentThree.text = contentThreeStr;
    contentThree.textColor = SGColorWithBlackOfDark;
    contentThree.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentThree.numberOfLines = 0;
    // 计算内容的size
    CGSize contentThreeSize = [SGHelperTool SG_sizeWithText:contentThreeStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentThree.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleThree.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentThreeSize.height);
    [_bgScrollView addSubview:contentThree];
  
#pragma mark - - - 协议四
    UILabel *titleFour = [[UILabel alloc] init];
    NSString *titleFourStr = @"第四条 资金管理";
    titleFour.text = titleFourStr;
    titleFour.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleFour.numberOfLines = 0;
    // 计算内容的size
    CGSize titleFourSize = [SGHelperTool SG_sizeWithText:titleFourStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleFour.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentThree.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleFourSize.height);
    [_bgScrollView addSubview:titleFour];
    
    UILabel *contentFour = [[UILabel alloc] init];
    NSString *contentFourStr = @"4.1. 您同意温州乐商投资有限公司、其关联方或合作方向您提供资金存管服务，温州乐商投资有限公司、其关联方或合作方根据业务需要自主决定，是否在银行为您开立专门用于办理资金存管业务的资金账户。您通过乐商贷出借资金，乐商贷和/或乐商贷委托的第三方机构将为您提供“资金管理技术服务”，主要包括但不限于：资金的充值、提现、查询、代收、代付等。您可以通过乐商贷有关页面的具体规则或说明详细了解。\n\n4.2. 您了解，上述技术服务涉及乐商贷与第三方支付机构及金融机构的合作。您同意：\n(a) 受第三方支付机构和金融机构可能仅在工作日进行资金代扣及划转的现状等各种原因所限，乐商贷不对资金到账时间做任何承诺，也不承担与此相关的责任，包括但不限于由此产生的利息、货币贬值等损失；\n(b) 一经您使用前述服务，即表示您不可撤销地授权乐商贷进行相关操作，且该等操作是不可逆转的，您不能以任何理由拒绝付款或要求取消交易。就前述服务，您应按照有关文件及第三方支付机构和金融机构的规定支付相关费用，您与第三方支付机构和金融机构之间就费用支付事项产生的争议或纠纷，与乐商贷无关。\n\n4.3. 您承诺通过乐商贷平台进行交易的资金来源合法。您同意，乐商贷有权按照包括但不限于公安机关、司法机关、行政机关、军事机关的要求协助对您的账户及资金等进行查询、冻结或扣划等操作。\n\n4.4. 乐商贷有权基于交易安全等方面的考虑设定交易限额。您了解，乐商贷的前述设定可能会对您的交易造成一定不便，您对此没有异议。\n\n4.5. 如果乐商贷发生了因系统故障或其他原因导致的处理错误，无论有利于乐商贷还是有利于您，乐商贷都有权在根据本协议规定通知您后纠正该错误。如果该错误导致您实际收到的金额少于您应获得的金额，则乐商贷在确认该处理错误后会尽快将您应收金额与实收金额之间的差额存入您的用户账户。如果该错误导致您实际收到的金额多于您应获得的金额，则无论错误归责于谁，您都应及时根据乐商贷向您发出的有关纠正错误的通知的具体要求返还多收的款项。您理解并同意，因前述处理错误而多付或少付的款项均不计利息，乐商贷不承担因前述处理错误而导致的任何损失或责任。\n\n4.6. 在任何情况下，乐商贷不承担第三方的任何责任。因您自身的原因导致乐商贷的服务无法提供或提供时发生任何错误而产生的任何损失或责任，由您自行负责，乐商贷不承担责任。";
    contentFour.text = contentFourStr;
    contentFour.textColor = SGColorWithBlackOfDark;
    contentFour.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentFour.numberOfLines = 0;
    // 计算内容的size
    CGSize contentFourSize = [SGHelperTool SG_sizeWithText:contentFourStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentFour.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleFour.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentFourSize.height);
    [_bgScrollView addSubview:contentFour];
    
#pragma mark - - - 协议五
    UILabel *titleFive = [[UILabel alloc] init];
    NSString *titleFiveStr = @"第五条 电子合同";
    titleFive.text = titleFiveStr;
    titleFive.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleFive.numberOfLines = 0;
    // 计算内容的size
    CGSize titleFiveSize = [SGHelperTool SG_sizeWithText:titleFiveStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleFive.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentFour.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleFiveSize.height);
    [_bgScrollView addSubview:titleFive];
    
    UILabel *contentFive = [[UILabel alloc] init];
    NSString *contentFiveStr = @"5.1. 在乐商贷平台交易需订立的协议采用电子合同方式，可以有一份或者多份并且每一份具有同等法律效力。您知道、了解电子签章的概念、定义和效力，同意采用电子签章的方式进行签署电子合同，是您本人真实意愿并以您本人名义签署。您应妥善保管自己的账户密码等重要信息，您不得以账户密码信息被盗用为由否认已订立的合同的效力或不按照该等合同履行相关义务。\n\n5.2. 您根据本协议以及乐商贷的相关规则签署电子合同后，不得擅自修改该合同。乐商贷向您提供电子合同的保管查询、核对等服务，如对电子合同真伪或电子合同的内容有任何疑问，您可通过乐商贷官方客服4000-333-113查阅合同并进行核对，如对此有任何争议，应以乐商贷系统内留存的合同为准。";
    contentFive.text = contentFiveStr;
    contentFive.textColor = SGColorWithBlackOfDark;
    contentFive.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentFive.numberOfLines = 0;
    // 计算内容的size
    CGSize contentFiveSize = [SGHelperTool SG_sizeWithText:contentFiveStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentFive.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleFive.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentFiveSize.height);
    [_bgScrollView addSubview:contentFive];
    
#pragma mark - - - 协议六
    UILabel *titleSix = [[UILabel alloc] init];
    NSString *titleSixStr = @"第六条 用户信息及隐私权保护";
    titleSix.text = titleSixStr;
    titleSix.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleSix.numberOfLines = 0;
    // 计算内容的size
    CGSize titleSixSize = [SGHelperTool SG_sizeWithText:titleSixStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleSix.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentFive.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleSixSize.height);
    [_bgScrollView addSubview:titleSix];
    
    UILabel *contentSix = [[UILabel alloc] init];
    NSString *contentSixStr = @"6.1. 您同意本网站在业务运营中收集和储存您的用户信息，包括但不限于您自行提供的资料和信息，以及本网站自行收集、取得的您在本网站的交易记录和使用信息等。本网站收集和储存您的用户信息的目的在于提高为您提供服务的效率和质量。\n\n6.2. 您同意本网站在业务运营中使用您的用户信息，包括但不限于(1)进行用户身份、信息核实；（2）出于提供服务的需要在本网站公示您的相关信息；(3)向本网站的合作机构（该合作机构仅限于本网站为了完成拟向您提供的服务而合作的机构）提供您的用户信息；(4)由人工或自动程序对您信息进行评估、分类、研究；(5)使用您的用户信息以改进本网站的推广；(6)使用您提供的联系方式与您联络并向您传递有关业务和管理方面的信息。（7）用于配合有权机关依职权调取证据材料。";
    contentSix.text = contentSixStr;
    contentSix.textColor = SGColorWithBlackOfDark;
    contentSix.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentSix.numberOfLines = 0;
    // 计算内容的size
    CGSize contentSixSize = [SGHelperTool SG_sizeWithText:contentSixStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentSix.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleSix.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentSixSize.height);
    [_bgScrollView addSubview:contentSix];
    
#pragma mark - - - 协议七
    UILabel *titleSeven = [[UILabel alloc] init];
    NSString *titleSevenStr = @"第七条 用户承诺和保证";
    titleSeven.text = titleSevenStr;
    titleSeven.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleSeven.numberOfLines = 0;
    // 计算内容的size
    CGSize titleSevenSize = [SGHelperTool SG_sizeWithText:titleSevenStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleSeven.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentSix.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleSevenSize.height);
    [_bgScrollView addSubview:titleSeven];
    
    UILabel *contentSeven = [[UILabel alloc] init];
    NSString *contentSevenStr = @"7.1. 本网站用户应保证严格遵守中国现行法律、法规、政府规章及其他应该遵守的规范性文件，不在本网站从事危害国家安全、洗钱、套现、传销等任何违法活动或者其他有违社会公共利益或公共道德的行为。同时，本网站的投资人应保证所用于投资（出借）的资金来源合法，投资人是该资金的合法所有权人，如果因第三人对用于投资（出借）的资金的来源合法性或归属问题发生争议，由投资人负责解决并承担一切由此而导致的损失和责任。\n\n7.2.您确认在签署本协议之前已阅读包括但不限于以下与本协议及相关协议的订立及履行有关的风险提示，并对该等风险有充分理解和预期，您自愿承担该等风险可能给带来的一切责任和损失和责任。\n(1)政策风险：国家因宏观政策、财政政策、货币政策、行业政策、地区发展政策等因素引起的系统风险。\n(2)借款人及担保信用风险：当借款人及担保（如有）短期或者长期丧失还款能力（包括但不限于借款人收入情况、财产状况发生变化、人身出现意外、发生疾病、死亡等情况），或者借款人及担保（如有）的还款意愿发生变化时，您的出借资金及利息可能无法按时回收甚至无法回收。\n(3)不可抗力：由于本网站及相关第三方的设备、系统故障或缺陷、病毒、黑客攻击、网络故障、网络中断、地震、台风、水灾、海啸、雷电、火灾、瘟疫、流行病、战争、恐怖主义、敌对行为、暴动、罢工、交通中断、停止供应主要服务、电力中断、经济形势严重恶化或其它类似事件导致的风险。";
    contentSeven.text = contentSevenStr;
    contentSeven.textColor = SGColorWithBlackOfDark;
    contentSeven.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentSeven.numberOfLines = 0;
    // 计算内容的size
    CGSize contentSevenSize = [SGHelperTool SG_sizeWithText:contentSevenStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentSeven.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleSeven.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentSevenSize.height);
    [_bgScrollView addSubview:contentSeven];
    
#pragma mark - - - 协议八
    UILabel *titleEight = [[UILabel alloc] init];
    NSString *titleEightStr = @"第八条 免责声明";
    titleEight.text = titleEightStr;
    titleEight.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleEight.numberOfLines = 0;
    // 计算内容的size
    CGSize titleEightSize = [SGHelperTool SG_sizeWithText:titleEightStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleEight.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentSeven.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleEightSize.height);
    [_bgScrollView addSubview:titleEight];
    
    UILabel *contentEight = [[UILabel alloc] init];
    NSString *contentEightStr = @"8.1 除非另有书面协议约定，本网站在任何情况下，对用户使用本网站服务而产生的任何形式的直接或间接损失均不承担法律责任，包括但不限于资金损失、收益损失等。\n\n8.2 用户信息主要由用户自行提供或发布，本网站无法保证所有用户信息的真实、及时和完整，用户应对自己的判断承担全部责任。任何因为交易而产生的风险概由各交易方自行承担。\n\n8.3 任何本网站之外的第三方机构或个人所提供的服务，其服务品质及内容由该第三方自行、独立负责。\n\n8.4 因不可抗力或本网站服务器死机、网络故障、数据库故障、软件升级等问题造成的服务中断和对用户个人数据及资料造成的损失，本网站不承担任何责任，亦不予赔偿，但将尽力减少因此而给用户造成的损失和影响。\n\n8.5 因黑客、病毒或密码被盗、泄露等非本网站原因所造成损失概由您本人自行承担。\n\n8.6 您须对您本人在使用本网站所提供的服务时的一切行为、行动（不论是否故意）负全部责任。\n\n8.7 当司法机关、政府部门或其他监管机构根据有关法律、法规、规章及其他政府规范性文件的规定和程序，要求本网站提供用户信息资料，本网站对据此作出的任何披露，概不承担责任。";
    contentEight.text = contentEightStr;
    contentEight.textColor = SGColorWithBlackOfDark;
    contentEight.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentEight.numberOfLines = 0;
    // 计算内容的size
    CGSize contentEightSize = [SGHelperTool SG_sizeWithText:contentEightStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentEight.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleEight.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentEightSize.height);
    [_bgScrollView addSubview:contentEight];
    
#pragma mark - - - 协议九
    UILabel *titleNine = [[UILabel alloc] init];
    NSString *titleNineStr = @"第九条 协议终止及账户的暂停或终止";
    titleNine.text = titleNineStr;
    titleNine.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleNine.numberOfLines = 0;
    // 计算内容的size
    CGSize titleNineSize = [SGHelperTool SG_sizeWithText:titleNineStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleNine.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentEight.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleNineSize.height);
    [_bgScrollView addSubview:titleNine];
    
    UILabel *contentNine = [[UILabel alloc] init];
    NSString *contentNineStr = @"9.1 如果您决定不再使用乐商贷服务时，应首先清偿所有应付款项（包括但不限于服务费、违约金、管理费等），再将您的用户账户下所对应的可用款项（如有）全部提现或者向乐商贷发出其它合法的支付指令。乐商贷不提供账户注销功能。\n\n9.2 您若发现有第三人冒用或盗用您的用户账户及密码，或其他任何未经合法授权的情形，应立即以有效方式通知乐商贷，要求暂停相关服务，否则由此产生的一切责任由您本人承担。同时，您理解乐商贷对您的请求采取行动需要合理期限，在此之前，乐商贷对第三人使用该服务所导致的损失不承担任何责任。\n\n9.3 乐商贷有权基于单方独立判断，在认为可能发生危害交易安全等情形时，不经通知而先行暂停、中断或终止向您提供本协议项下的全部或部分用户服务（包括收费服务），并将注册资料移除或删除，且无需对用户或任何第三方承担任何责任。\n\n9.4 无论乐商贷是否收费，只要您利用本网站从事违法活动或者严重违反本协议的约定，乐商贷可在不发出任何通知的情况下立即使您的账户无效，或撤销您的账户以及在您的账户内的所有相关资料和档案，和/或禁止用户进一步接入该等档案或服务。\n\n9.5 用户账户的暂停、中断不代表用户责任的终止，用户仍应对其使用乐商贷提供服务期间的行为承担可能的违约或损害赔偿责任，同时乐商贷仍可保有用户的相关信息。";
    contentNine.text = contentNineStr;
    contentNine.textColor = SGColorWithBlackOfDark;
    contentNine.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentNine.numberOfLines = 0;
    // 计算内容的size
    CGSize contentNineSize = [SGHelperTool SG_sizeWithText:contentNineStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentNine.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleNine.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentNineSize.height);
    [_bgScrollView addSubview:contentNine];
    
#pragma mark - - - 协议十
    UILabel *titleTen = [[UILabel alloc] init];
    NSString *titleTenStr = @"第十条 通知";
    titleTen.text = titleTenStr;
    titleTen.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleTen.numberOfLines = 0;
    // 计算内容的size
    CGSize titleTenSize = [SGHelperTool SG_sizeWithText:titleTenStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleTen.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentNine.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleTenSize.height);
    [_bgScrollView addSubview:titleTen];
    
    UILabel *contentTen = [[UILabel alloc] init];
    NSString *contentTenStr = @"本协议项下的通知如以公示方式作出，一经在公示即视为已经送达。除此之外，其他向您个人发布的具有专属性的通知将由乐商贷向您在注册时提供的手机号码，或乐商贷在您的个人账户中为您设置的站内消息系统栏发送，一经发送即视为已经送达。请您密切关注您站内消息系统栏中的邮件、信息及手机中的短信信息。您同意乐商贷出于向您提供服务之目的，可以向您的电子邮箱、站内消息系统栏和手机发送有关通知或提醒；若您不愿意接收，请在乐商贷相应系统板块进行设置。但您同时同意并确认，若您设置了不接收有关通知或提醒，则您有可能收不到该等通知信息，您不得以您未收到或未阅读该等通知信息主张相关通知未送达于您。";
    contentTen.text = contentTenStr;
    contentTen.textColor = SGColorWithBlackOfDark;
    contentTen.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentTen.numberOfLines = 0;
    // 计算内容的size
    CGSize contentTenSize = [SGHelperTool SG_sizeWithText:contentTenStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentTen.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleTen.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentTenSize.height);
    [_bgScrollView addSubview:contentTen];
    
#pragma mark - - - 协议十一
    UILabel *titleEleven = [[UILabel alloc] init];
    NSString *titleElevenStr = @"第十一条 不可抗力或者意外事件";
    titleEleven.text = titleElevenStr;
    titleEleven.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleEleven.numberOfLines = 0;
    // 计算内容的size
    CGSize titleElevenSize = [SGHelperTool SG_sizeWithText:titleElevenStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleEleven.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentTen.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleElevenSize.height);
    [_bgScrollView addSubview:titleEleven];
    
    UILabel *contentEleven = [[UILabel alloc] init];
    NSString *contentElevenStr = @"因不可抗力或者其他意外事件，该等事件包括但不限于互联网连接故障、电脑或通讯以及其他系统的故障、电力故障、黑客攻击、网络病毒、电信部门技术管制、自然灾害、罢工或骚乱、物质短缺或定量配给、暴动、战争行为、政府行为等， 致使乐商贷暂停或延迟或未能履约或终止服务的，不视为违约，乐商贷不对此承担任何责任。";
    contentEleven.text = contentElevenStr;
    contentEleven.textColor = SGColorWithBlackOfDark;
    contentEleven.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentEleven.numberOfLines = 0;
    // 计算内容的size
    CGSize contentElevenSize = [SGHelperTool SG_sizeWithText:contentElevenStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentEleven.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleEleven.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentElevenSize.height);
    [_bgScrollView addSubview:contentEleven];
    
#pragma mark - - - 协议十二
    UILabel *titleTwelve = [[UILabel alloc] init];
    NSString *titleTwelveStr = @"第十二条 税费缴纳";
    titleTwelve.text = titleTwelveStr;
    titleTwelve.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleTwelve.numberOfLines = 0;
    // 计算内容的size
    CGSize titleTwelveSize = [SGHelperTool SG_sizeWithText:titleTwelveStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleTwelve.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentEleven.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleTwelveSize.height);
    [_bgScrollView addSubview:titleTwelve];
    
    UILabel *contentTwelve = [[UILabel alloc] init];
    NSString *contentTwelveStr = @"您通过乐商贷投资的资金（出借）、收益过程产生的相关税收缴纳义务，请根据中国法律的规定自行向其主管税务机关申报、缴纳，本网站不承担任何代扣代缴的义务及责任。";
    contentTwelve.text = contentTwelveStr;
    contentTwelve.textColor = SGColorWithBlackOfDark;
    contentTwelve.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentTwelve.numberOfLines = 0;
    // 计算内容的size
    CGSize contentTwelveSize = [SGHelperTool SG_sizeWithText:contentTwelveStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentTwelve.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleTwelve.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentTwelveSize.height);
    [_bgScrollView addSubview:contentTwelve];
    
#pragma mark - - - 协议十三
    UILabel *titleThirteen = [[UILabel alloc] init];
    NSString *titleThirteenStr = @"第十三条 适用法律和管辖";
    titleThirteen.text = titleThirteenStr;
    titleThirteen.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleThirteen.numberOfLines = 0;
    // 计算内容的size
    CGSize titleThirteenSize = [SGHelperTool SG_sizeWithText:titleThirteenStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleThirteen.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentTwelve.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleThirteenSize.height);
    [_bgScrollView addSubview:titleThirteen];
    
    UILabel *contentThirteen = [[UILabel alloc] init];
    NSString *contentThirteenStr = @"您通过乐商贷投资（出借）的资金的继承或赠与，必须由主张权利的继承人或受赠人向乐商贷出示经公证机关公证的继承或赠与权利归属证明文件，经乐商贷确认后方可予以协助办理资产权属变更手续，由此产生的相关税费，由主张权利的继承人或受赠人向其主管税务机关申报、缴纳，乐商贷不负责相关事宜处理。";
    contentThirteen.text = contentThirteenStr;
    contentThirteen.textColor = SGColorWithBlackOfDark;
    contentThirteen.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentThirteen.numberOfLines = 0;
    // 计算内容的size
    CGSize contentThirteenSize = [SGHelperTool SG_sizeWithText:contentThirteenStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentThirteen.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleThirteen.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentThirteenSize.height);
    [_bgScrollView addSubview:contentThirteen];
    
#pragma mark - - - 协议十四
    UILabel *titlefourteen = [[UILabel alloc] init];
    NSString *titlefourteenStr = @"第十四条 适用法律和管辖";
    titlefourteen.text = titlefourteenStr;
    titlefourteen.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titlefourteen.numberOfLines = 0;
    // 计算内容的size
    CGSize titlefourteenSize = [SGHelperTool SG_sizeWithText:titlefourteenStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titlefourteen.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentThirteen.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titlefourteenSize.height);
    [_bgScrollView addSubview:titlefourteen];
    
    UILabel *contentfourteen = [[UILabel alloc] init];
    NSString *contentfourteenStr = @"因乐商贷所提供服务而产生的争议均适用中华人民共和国法律，并由乐商贷所在地有管辖权的人民法院受理。";
    contentfourteen.text = contentfourteenStr;
    contentfourteen.textColor = SGColorWithBlackOfDark;
    contentfourteen.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentfourteen.numberOfLines = 0;
    // 计算内容的size
    CGSize contentfourteenSize = [SGHelperTool SG_sizeWithText:contentfourteenStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentfourteen.frame = CGRectMake(SGMargin, CGRectGetMaxY(titlefourteen.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentfourteenSize.height);
    [_bgScrollView addSubview:contentfourteen];
    
#pragma mark - - - 协议十五
    UILabel *titleFifteen = [[UILabel alloc] init];
    NSString *titleFifteenStr = @"第十五条 其他";
    titleFifteen.text = titleFifteenStr;
    titleFifteen.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleFifteen.numberOfLines = 0;
    // 计算内容的size
    CGSize titleFifteenSize = [SGHelperTool SG_sizeWithText:titleFifteenStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    titleFifteen.frame = CGRectMake(SGMargin, CGRectGetMaxY(contentfourteen.frame) + SGMargin + SGSmallMargin, SG_screenWidth - 2 * SGMargin, titleFifteenSize.height);
    [_bgScrollView addSubview:titleFifteen];
    
    UILabel *contentFifteen = [[UILabel alloc] init];
    NSString *contentFifteenStr = @"乐商贷对本协议拥有最终的解释权。本协议及乐商贷有关页面的相关名词可互相引用参照，如有不同理解，则以本协议条款为准。此外，若本协议的部分条款被认定为无效或者无法实施时，本协议中的其他条款仍然有效。";
    contentFifteen.text = contentFifteenStr;
    contentFifteen.textColor = SGColorWithBlackOfDark;
    contentFifteen.font = [UIFont systemFontOfSize:SGTextFontWith13];
    contentFifteen.numberOfLines = 0;
    // 计算内容的size
    CGSize contentFifteenSize = [SGHelperTool SG_sizeWithText:contentFifteenStr font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(SG_screenWidth - 2 * SGMargin, MAXFLOAT)];
    contentFifteen.frame = CGRectMake(SGMargin, CGRectGetMaxY(titleFifteen.frame) + SGMargin, SG_screenWidth - 2 * SGMargin, contentFifteenSize.height);
    [_bgScrollView addSubview:contentFifteen];
    
    _bgScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(contentFifteen.frame) + 2 * SGMargin);
}






@end
