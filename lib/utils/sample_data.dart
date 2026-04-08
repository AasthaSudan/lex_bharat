import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class LegalContentService {
  static List<Map<String, dynamic>>? _cachedCategories;
  static List<Map<String, dynamic>>? _cachedMappings;

  static const Map<String, IconData> _iconMap = {
    'shield': Icons.shield_rounded,
    'work': Icons.work_rounded,
    'female': Icons.female_rounded,
    'shopping_cart': Icons.shopping_cart_rounded,
    'home': Icons.home_rounded,
    'gavel': Icons.gavel_rounded,
    'computer': Icons.computer_rounded,
    'info': Icons.info_rounded,
    'family_restroom': Icons.family_restroom_rounded,
    'school': Icons.school_rounded,
    'groups': Icons.groups_rounded,
    'eco': Icons.eco_rounded,
  };

  static Color _parseColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  static Future<List<Map<String, dynamic>>> getCategories({String lang = 'en'}) async {
    if (_cachedCategories != null) {
      return _formatCategories(_cachedCategories!, lang);
    }

    try {
      final jsonStr = await rootBundle.loadString('assets/data/legal_content.json');
      final data = json.decode(jsonStr);
      _cachedCategories = List<Map<String, dynamic>>.from(data['categories']);
      return _formatCategories(_cachedCategories!, lang);
    } catch (e) {
      debugPrint('Failed to load legal content: $e');
      return SampleData.getLegalCategories(); // fallback
    }
  }

  static List<Map<String, dynamic>> _formatCategories(List<Map<String, dynamic>> raw, String lang) {
    return raw.map((cat) {
      final isHindi = lang == 'hi';
      return {
        'title': isHindi ? (cat['title_hi'] ?? cat['title']) : cat['title'],
        'icon': _iconMap[cat['icon']] ?? Icons.article_rounded,
        'color': _parseColor(cat['color']),
        'topics': (cat['topics'] as List).map((t) => {
          'title': isHindi ? (t['title_hi'] ?? t['title']) : t['title'],
          'content': t['content'], // content stays English for now
        }).toList(),
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getIPCBNSMappings() async {
    if (_cachedMappings != null) return _cachedMappings!;

    try {
      final jsonStr = await rootBundle.loadString('assets/data/ipc_bns_mapping.json');
      final data = json.decode(jsonStr);
      _cachedMappings = List<Map<String, dynamic>>.from(data['mappings']);
      return _cachedMappings!;
    } catch (e) {
      debugPrint('Failed to load IPC-BNS mappings: $e');
      return [];
    }
  }
}

class SampleData {
  static List<Map<String, dynamic>> getLegalCategories() {
    return [
      {
        'title': 'Labor Rights',
        'icon': Icons.work_rounded,
        'color': AppColors.categoryBlue,
        'topics': [
          {
            'title': 'Minimum Wage Rights',
            'content':
            'Under the Code on Wages 2019, every worker in India is entitled to minimum wage. State governments set rates for different industries and skill levels.\n\nKey Points:\n• Minimum wage varies by state and industry\n• Both skilled and unskilled workers are covered\n• Employers must display minimum wage notices\n• Non-payment is punishable with fine and imprisonment\n• You can check current rates at your state Labour Department website\n\nIf unpaid: File complaint with Labour Commissioner or approach Labour Court. You can also call the National Labour Helpline: 1800-180-0099\n\nThis is for educational purposes only. Consult a qualified lawyer for legal advice.',
          },
          {
            'title': 'Overtime Pay',
            'content':
            'The Factories Act 1948 and Shops & Establishments Acts guarantee overtime pay for work beyond standard hours.\n\nStandard Hours:\n• 8 hours per day, 48 hours per week\n• Overtime applies beyond 9 hours/day\n\nOvertime Rate:\n• Double the normal wage rate\n• Must be paid within the same wage period\n\nYour Rights:\n• Cannot be forced to work overtime without consent\n• Overtime wages cannot be waived by agreement\n• Keep your own record of actual hours worked\n\nIf denied: File complaint with labour inspector or approach Labour Commissioner.\n\nThis is for educational purposes only.',
          },
          {
            'title': 'Wrongful Termination',
            'content':
            'Protection against wrongful termination is provided under the Industrial Disputes Act 1947 and individual state laws.\n\nNotice Period:\n• Minimum 30 days notice for permanent employees\n• Payment in lieu of notice is allowed\n• Terms as per your employment contract\n\nYou CANNOT be fired for:\n• Union activities or membership\n• Filing a complaint against employer\n• Taking maternity or sick leave\n• Discriminatory reasons\n\nRemedies Available:\n• File complaint with Labour Commissioner\n• Approach Labour Court or Industrial Tribunal\n• Seek reinstatement and back wages\n• Get free legal aid from DLSA\n\nThis is for educational purposes only.',
          },
          {
            'title': 'Provident Fund (EPF)',
            'content':
            'The Employees\' Provident Fund (EPF) is a mandatory savings scheme under the EPF Act 1952.\n\nEligibility:\n• All employees earning up to ₹15,000/month must be enrolled\n• Voluntary for those earning above ₹15,000\n\nContributions:\n• Employee: 12% of basic salary\n• Employer: 12% of basic salary (split between EPF and EPS)\n\nYour Rights:\n• Cannot be denied EPF enrollment\n• Full withdrawal on retirement or after 2 months of unemployment\n• Partial withdrawal for house, marriage, education, medical\n\nCheck balance: EPFO portal (epfindia.gov.in) or missed call to 011-22901406\n\nComplaints: EPFiGMS portal or call 1800-118-005 (free)\n\nThis is for educational purposes only.',
          },
        ],
      },
      {
        'title': 'Property Rights',
        'icon': Icons.home_rounded,
        'color': AppColors.categoryGreen,
        'topics': [
          {
            'title': 'Tenant Rights',
            'content':
            'Tenants in India are protected under state Rent Control Acts and the Model Tenancy Act 2021.\n\nKey Tenant Rights:\n• Right to a written rent agreement\n• Right to peaceful possession of the property\n• Protection from arbitrary rent hikes\n• Right to basic amenities (water, electricity)\n• Security deposit cannot exceed 2 months rent (Model Act)\n\nLandlord CANNOT:\n• Enter without prior notice (except emergency)\n• Cut off utilities to force eviction\n• Change locks without court order\n• Evict without proper legal notice\n\nIf harassed: Approach Rent Authority or District Court. File police complaint for illegal eviction.\n\nAlways register your rent agreement. Keep copies of all payments.\n\nThis is for educational purposes only.',
          },
          {
            'title': 'Eviction Rules',
            'content':
            'Eviction in India requires following a strict legal process. A landlord cannot evict you without a court order in most cases.\n\nValid Grounds for Eviction:\n• Genuine non-payment of rent (after notice)\n• Subletting without permission\n• Misuse or damage to property\n• Landlord needs property for personal use\n• End of registered lease period\n\nLegal Eviction Process:\n1. Written notice (15 days to 6 months depending on state)\n2. File eviction petition in Rent Court\n3. Court hearing and your right to contest\n4. Court order for possession\n\nIllegal Eviction Signs (report to police):\n• Forcible lock change\n• Cutting electricity/water\n• Physical intimidation or threats\n\nThis is for educational purposes only.',
          },
          {
            'title': 'Property Registration',
            'content':
            'Property registration is mandatory under the Registration Act 1908. An unregistered sale deed has no legal value.\n\nWhy Register:\n• Creates legal title in your name\n• Protects against fraud and double sales\n• Required to claim ownership in court\n• Essential for bank loans\n\nProcess:\n1. Execute sale deed with seller\n2. Pay stamp duty (varies by state, typically 5-7%)\n3. Pay registration fee (1% of property value)\n4. Register at Sub-Registrar\'s office within 4 months\n5. Both parties must be present with witnesses\n\nDocuments Needed:\n• Sale deed, ID proof, address proof\n• Property tax receipts, encumbrance certificate\n• NOC from housing society if applicable\n\nCheck land records: Your state\'s Bhoomi/Dharani/land records portal\n\nThis is for educational purposes only.',
          },
        ],
      },
      {
        'title': 'Women\'s Rights',
        'icon': Icons.female_rounded,
        'color': AppColors.categoryPink,
        'topics': [
          {
            'title': 'Domestic Violence',
            'content':
            'The Protection of Women from Domestic Violence Act 2005 provides comprehensive civil law protection.\n\nWhat Qualifies as Domestic Violence:\n• Physical abuse (hitting, slapping, kicking)\n• Sexual abuse within marriage\n• Verbal and emotional abuse (insults, threats)\n• Economic abuse (denying money, taking salary)\n• Any harassment of family members\n\nWho Can File:\n• Wife or female partner\n• Mother, sister, daughter of the abuser\n• Any woman in a domestic relationship\n\nImmediate Help:\n• Call Women Helpline: 1091 (24/7, free)\n• Call National Emergency: 112\n• Approach nearest Protection Officer (at District Women & Child office)\n\nRelief Available:\n• Protection orders\n• Residence orders (cannot be thrown out)\n• Monetary relief\n• Custody of children\n\nThis is for educational purposes only.',
          },
          {
            'title': 'Workplace Sexual Harassment',
            'content':
            'The Sexual Harassment of Women at Workplace (Prevention, Prohibition & Redressal) Act 2013 (POSH Act) protects all working women.\n\nWhat is Sexual Harassment:\n• Unwelcome physical contact\n• Demand or request for sexual favors\n• Sexually colored remarks or jokes\n• Showing pornography without consent\n• Any other unwelcome conduct of sexual nature\n\nEvery Workplace Must Have:\n• Internal Complaints Committee (ICC) if 10+ employees\n• External Complaints Committee for smaller workplaces\n\nHow to File Complaint:\n1. Write to your ICC within 3 months of incident\n2. ICC must complete inquiry in 90 days\n3. If employer does nothing, approach District Officer\n\nProtections:\n• Confidentiality must be maintained\n• No retaliation allowed\n• Can request transfer during inquiry\n\nCall iCall: 9152987821 for support\n\nThis is for educational purposes only.',
          },
          {
            'title': 'Maternity Benefits',
            'content':
            'The Maternity Benefit (Amendment) Act 2017 provides comprehensive maternity protection.\n\nMaternity Leave:\n• 26 weeks paid leave for first two children\n• 12 weeks for third child onwards\n• 12 weeks for adoption or surrogacy\n• Applicable to women who worked 80+ days in last 12 months\n\nOther Benefits:\n• Cannot be dismissed during pregnancy\n• Must be offered lighter duties if needed\n• Nursing breaks (2 per day) for children under 15 months\n• Crèche facility if employer has 50+ employees\n\nApplicable to:\n• All establishments with 10+ employees\n• Government and private sector\n\nIf employer refuses: File complaint with Inspector under Maternity Benefit Act in your district.\n\nThis is for educational purposes only.',
          },
        ],
      },
      {
        'title': 'Consumer Rights',
        'icon': Icons.shopping_cart_rounded,
        'color': AppColors.categoryOrange,
        'topics': [
          {
            'title': 'Consumer Rights Overview',
            'content':
            'The Consumer Protection Act 2019 gives you 6 fundamental rights as a consumer.\n\n6 Consumer Rights:\n1. Right to Safety — protection from hazardous goods\n2. Right to Information — know product details, price, quality\n3. Right to Choose — access to variety at competitive prices\n4. Right to be Heard — grievances must be addressed\n5. Right to Redressal — compensation for defective goods/services\n6. Right to Consumer Education — know your rights\n\nWhere to Complain:\n• District Consumer Forum: claims up to ₹50 lakhs\n• State Commission: ₹50 lakhs to ₹2 crores\n• National Commission: above ₹2 crores\n• Online: consumerhelpline.gov.in\n• Helpline: 1915 or 1800-11-4000 (free)\n\nNo fees for claims up to ₹5 lakhs. Simple process, no lawyer required.\n\nThis is for educational purposes only.',
          },
          {
            'title': 'Filing Consumer Complaints',
            'content':
            'Filing a consumer complaint in India is simple and mostly free.\n\nStep 1: Try to resolve directly\n• Contact seller/company customer care\n• Send written complaint and keep copy\n• Give 15-30 days to respond\n\nStep 2: File online complaint\n• Visit edaakhil.nic.in (National Consumer Portal)\n• Register free account\n• Fill complaint form with details\n• Attach receipts, bills, photos, correspondence\n• Claims up to ₹5 lakh: no fee\n\nStep 3: Physical complaint\n• Visit District Consumer Disputes Redressal Commission\n• Fill complaint form, attach documents\n• Pay nominal filing fee\n\nDocuments to Keep:\n• Original bill/receipt\n• Warranty card\n• Product photos showing defect\n• All communication with seller\n\nTime Limit: File within 2 years of purchase/service\n\nThis is for educational purposes only.',
          },
          {
            'title': 'E-Commerce Rights',
            'content':
            'The Consumer Protection (E-Commerce) Rules 2020 protect online shoppers in India.\n\nYour Rights When Shopping Online:\n• Clear disclosure of seller details, prices, fees\n• No hidden charges at checkout\n• Easy cancellation and refund process\n• 30-day return window cannot be less than 7 days\n• Grievance officer must respond in 48 hours\n\nFor Defective Products:\n• Seller must accept return/replace/refund\n• Cannot refuse service based on location\n• No fake reviews or manipulated search results\n\nFor Fraud/Non-Delivery:\n• File complaint on National Cyber Crime portal: cybercrime.gov.in\n• Call: 1930 (Cyber Crime Helpline)\n• File consumer complaint at edaakhil.nic.in\n\nFor Payment Issues:\n• Report to your bank immediately\n• File complaint with RBI Ombudsman: cms.rbi.org.in\n\nThis is for educational purposes only.',
          },
        ],
      },
      {
        'title': 'Criminal Rights',
        'icon': Icons.gavel_rounded,
        'color': AppColors.categoryPurple,
        'topics': [
          {
            'title': 'Your Rights if Arrested',
            'content':
            'Indian law provides strong protections for people who are arrested.\n\nImmediate Rights on Arrest:\n• Right to know the grounds of arrest (Article 22)\n• Right to be produced before magistrate within 24 hours\n• Right to inform family/friend of arrest\n• Right to consult a lawyer of your choice\n• Right to free legal aid if you cannot afford a lawyer\n• Right to remain silent (cannot be forced to confess)\n\nPolice CANNOT:\n• Arrest without warrant for most non-cognizable offenses\n• Detain beyond 24 hours without magistrate permission\n• Torture or use force during interrogation\n• Arrest women after 6 PM and before 6 AM (except emergency)\n\nIf Rights Violated:\n• File habeas corpus petition in High Court\n• File complaint with State Human Rights Commission\n• Call 100 or 112 if in danger\n\nThis is for educational purposes only.',
          },
          {
            'title': 'How to File an FIR',
            'content':
            'An FIR (First Information Report) under Section 154 CrPC is the first step in the criminal justice process.\n\nYour Rights:\n• Police MUST register FIR for cognizable offenses\n• Cannot be refused at any police station in India\n• If refused, complain to SP/DSP or Judicial Magistrate\n• You can also send FIR by registered post to SP\n• Zero FIR: register at any police station regardless of jurisdiction\n\nProcess:\n1. Go to nearest police station\n2. Give oral or written complaint\n3. Police will write it down\n4. Read it before signing\n5. Get a FREE copy of FIR (your right)\n6. Note the FIR number\n\nOnline FIR:\n• Most states have online FIR portals\n• Search: "[your state] online FIR"\n\nIf FIR not registered: File complaint before Magistrate under Section 156(3) CrPC\n\nThis is for educational purposes only.',
          },
        ],
      },
      {
        'title': 'RTI & Government',
        'icon': Icons.account_balance_rounded,
        'color': AppColors.categoryTeal,
        'topics': [
          {
            'title': 'Right to Information (RTI)',
            'content':
            'The Right to Information Act 2005 gives every citizen the right to access information from government bodies.\n\nWhat You Can Ask:\n• Any information held by government offices\n• Copies of documents, records, contracts\n• Inspection of government works\n• Status of your pending applications\n• Details of government schemes and funds\n\nHow to File RTI:\n1. Write application to Public Information Officer (PIO)\n2. State: "I wish to seek information under RTI Act 2005"\n3. Clearly describe the information you want\n4. Pay ₹10 fee (postal order/DD/cash)\n5. Below Poverty Line applicants: free\n\nOnline RTI:\n• Central government: rtionline.gov.in\n• State portals available for most states\n\nTimelines:\n• Response within 30 days\n• 48 hours if life/liberty is involved\n• First appeal within 30 days if no response\n• Second appeal to Central/State Information Commissioner\n\nThis is for educational purposes only.',
          },
        ],
      },
    ];
  }

  static List<Map<String, dynamic>> getLegalForms() {
    return [
      {
        'id': 'fir',
        'title': 'Police Complaint (FIR)',
        'icon': Icons.local_police_rounded,
        'color': AppColors.error,
        'category': 'Criminal',
        'description': 'File a First Information Report with police',
        'fieldsCount': 8,
        'estimatedTime': 10,
        'popular': true,
      },
      {
        'id': 'legal_aid',
        'title': 'Legal Aid Application',
        'icon': Icons.gavel_rounded,
        'color': AppColors.categoryBlue,
        'category': 'Legal Aid',
        'description': 'Apply for free legal assistance from DLSA',
        'fieldsCount': 6,
        'estimatedTime': 8,
        'popular': true,
      },
      {
        'id': 'consumer',
        'title': 'Consumer Complaint',
        'icon': Icons.shopping_bag_rounded,
        'color': AppColors.categoryOrange,
        'category': 'Consumer',
        'description': 'Report defective products or poor service',
        'fieldsCount': 7,
        'estimatedTime': 12,
        'popular': false,
      },
      {
        'id': 'labor',
        'title': 'Labor Grievance',
        'icon': Icons.work_rounded,
        'color': AppColors.categoryGreen,
        'category': 'Labor',
        'description': 'File workplace complaint for unpaid wages',
        'fieldsCount': 9,
        'estimatedTime': 15,
        'popular': false,
      },
      {
        'id': 'rti',
        'title': 'RTI Application',
        'icon': Icons.info_rounded,
        'color': AppColors.categoryPurple,
        'category': 'Government',
        'description': 'Request information from a government body',
        'fieldsCount': 5,
        'estimatedTime': 5,
        'popular': false,
      },
      {
        'id': 'domestic_violence',
        'title': 'Domestic Violence Complaint',
        'icon': Icons.shield_rounded,
        'color': AppColors.categoryPink,
        'category': 'Women Safety',
        'description': 'File complaint under DV Act 2005',
        'fieldsCount': 10,
        'estimatedTime': 15,
        'popular': false,
      },
    ];
  }

  static List<Map<String, dynamic>> getLegalResources() {
    return [
      {
        'name': 'National Legal Services Authority (NALSA)',
        'type': 'Legal Aid — Government',
        'phone': '1800-11-4001',
        'address': '12/11, Jam Nagar House, Shahjahan Road, New Delhi - 110011',
        'distance': 0.0,
        'services': ['Free legal aid', 'Lok Adalat', 'Legal awareness'],
      },
      {
        'name': 'National Commission for Women',
        'type': 'Women Rights — Government',
        'phone': '7827170170',
        'address': 'Plot No. 21, FC-33, Jasola Institutional Area, New Delhi - 110025',
        'distance': 0.0,
        'services': ['Women rights', 'Domestic violence', 'Workplace harassment'],
      },
      {
        'name': 'National Human Rights Commission',
        'type': 'Human Rights — Government',
        'phone': '1800-11-8588',
        'address': 'Manav Adhikar Bhawan, C-60, Sector 25, Noida - 201301',
        'distance': 0.0,
        'services': ['Human rights violations', 'Police brutality', 'Custodial deaths'],
      },
      {
        'name': 'National Consumer Disputes Redressal Commission',
        'type': 'Consumer Rights — Government',
        'phone': '1800-11-4000',
        'address': 'Upbhokta Nyay Bhawan, F-Block, GPO Complex, INA, New Delhi',
        'distance': 0.0,
        'services': ['Consumer complaints', 'Product defects', 'Service disputes'],
      },
      {
        'name': 'Central Bureau of Investigation (CBI)',
        'type': 'Law Enforcement — Government',
        'phone': '011-24368801',
        'address': 'CGO Complex, Lodhi Road, New Delhi - 110003',
        'distance': 0.0,
        'services': ['Corruption cases', 'Economic offenses', 'High-profile crimes'],
      },
      {
        'name': 'Cyber Crime Reporting Portal',
        'type': 'Cyber Crime — Government',
        'phone': '1930',
        'address': 'cybercrime.gov.in — File online complaint from anywhere',
        'distance': 0.0,
        'services': ['Online fraud', 'Cyber stalking', 'Financial fraud'],
      },
      {
        'name': 'Labour Commissioner Office',
        'type': 'Labor Rights — Government',
        'phone': '1800-180-0099',
        'address': 'Shram Shakti Bhawan, Rafi Marg, New Delhi - 110001',
        'distance': 0.0,
        'services': ['Wage disputes', 'Wrongful termination', 'EPF complaints'],
      },
      {
        'name': 'iCall — Psychological Helpline',
        'type': 'Mental Health — NGO',
        'phone': '9152987821',
        'address': 'TISS, V.N. Purav Marg, Deonar, Mumbai - 400088',
        'distance': 0.0,
        'services': ['Legal trauma support', 'Mental health', 'Crisis counseling'],
      },
    ];
  }
}