import 'package:flutter/material.dart';
import 'colors.dart';

class SampleData {
  static List<Map<String, dynamic>> getLegalCategories() {
    return [
      {
        'title': 'Labor Rights',
        'icon': Icons.work,
        'color': AppColors.categoryBlue,
        'topics': [
          {
            'title': 'Minimum Wage',
            'content':
            'Minimum wage in India varies by state. As per the Code on Wages 2019, every state sets its own minimum wage. You have the right to receive at least the minimum wage prescribed for your state and industry.\n\nKey Points:\n• Minimum wage differs across states\n• Covers both skilled and unskilled workers\n• Employers must display minimum wage notice\n• Non-payment is a punishable offense\n\nHow to Check:\nVisit your state labor department website or contact labor commissioner office for current minimum wage rates in your area.',
          },
          {
            'title': 'Overtime Pay',
            'content':
            'Under the Factories Act 1948 and Shops and Establishments Acts, workers are entitled to overtime pay for work beyond standard hours.\n\nStandard Working Hours:\n• 8 hours per day\n• 48 hours per week\n\nOvertime Rate:\n• Double the normal wage rate\n• Applies to work beyond 9 hours/day or 48 hours/week\n\nYour Rights:\n• Cannot be forced to work overtime without consent\n• Must be paid within 7 days of wage period\n• Keep records of actual hours worked',
          },
          {
            'title': 'Wrongful Termination',
            'content':
            'Protection against wrongful termination varies by employment type and tenure.\n\nNotice Period:\n• Generally 30 days for permanent employees\n• As per employment contract\n• Payment in lieu of notice possible\n\nGrounds for Termination:\n• Cannot be terminated for discriminatory reasons\n• Cannot be fired for union activities\n• Cannot be terminated during maternity leave\n\nRemedies:\n• File complaint with labor commissioner\n• Approach labor court\n• Seek legal aid if needed',
          },
        ],
      },
      {
        'title': 'Property Rights',
        'icon': Icons.home,
        'color': AppColors.categoryGreen,
        'topics': [
          {
            'title': 'Rent Agreements',
            'content':
            'A rent agreement is a legal contract between landlord and tenant outlining terms of tenancy.\n\nEssential Clauses:\n• Names of parties\n• Property description\n• Rent amount and due date\n• Security deposit\n• Duration of tenancy\n• Notice period\n• Maintenance responsibilities\n\nRegistration:\n• Mandatory if lease exceeds 11 months\n• Registration fee applies\n• Requires stamp duty payment\n\nTenant Rights:\n• Right to peaceful possession\n• Right to basic amenities\n• Protection from arbitrary rent increase',
          },
          {
            'title': 'Eviction Rules',
            'content':
            'Landlords must follow legal procedures for eviction.\n\nValid Grounds for Eviction:\n• Non-payment of rent (after proper notice)\n• Misuse of property\n• Subletting without permission\n• End of lease period\n\nEviction Process:\n• Written notice required (15 days to 1 month)\n• Cannot forcibly evict\n• Must approach Rent Control Court\n• Court order necessary\n\nIllegal Eviction:\n• Changing locks without notice\n• Cutting utilities\n• Physical intimidation\n• These are criminal offenses',
          },
        ],
      },
      {
        'title': 'Women\'s Rights',
        'icon': Icons.female,
        'color': AppColors.categoryPink,
        'topics': [
          {
            'title': 'Domestic Violence Act',
            'content':
            'Protection of Women from Domestic Violence Act 2005 provides comprehensive protection.\n\nWhat Constitutes Domestic Violence:\n• Physical abuse\n• Sexual abuse\n• Verbal and emotional abuse\n• Economic abuse\n\nYour Rights:\n• Right to reside in shared household\n• Monetary relief\n• Custody of children\n• Protection orders\n\nHow to Get Help:\n1. Call Women Helpline: 1091\n2. Approach Protection Officer\n3. File complaint with magistrate\n4. Seek shelter if needed\n\nRemember: Help is available 24/7',
          },
          {
            'title': 'Workplace Harassment',
            'content':
            'Sexual Harassment of Women at Workplace Act 2013 mandates safe workplace.\n\nWhat is Harassment:\n• Unwelcome sexual advances\n• Requests for sexual favors\n• Verbal or physical conduct of sexual nature\n• Creating hostile work environment\n\nEvery Organization Must Have:\n• Internal Complaints Committee (ICC)\n• 10+ employees requirement\n• External members including NGO representative\n\nFiling Complaint:\n• Within 3 months of incident\n• Written complaint to ICC\n• ICC must complete inquiry within 90 days\n• Protection against retaliation guaranteed',
          },
        ],
      },
      {
        'title': 'Consumer Rights',
        'icon': Icons.shopping_cart,
        'color': AppColors.categoryOrange,
        'topics': [
          {
            'title': 'Product Defects',
            'content':
            'Consumer Protection Act 2019 protects against defective products.\n\nYour Rights:\n• Right to safety from hazardous goods\n• Right to information about product\n• Right to replacement or refund\n• Right to compensation for loss\n\nDefective Product:\n• Manufacturing defects\n• Design flaws\n• Inadequate warnings\n• Does not meet promised standards\n\nRemedies Available:\n1. Replacement of product\n2. Full refund\n3. Compensation for damages\n4. Removal of defects\n\nHow to Complain:\n• Keep purchase receipt\n• Document defects with photos\n• Contact seller first\n• File with Consumer Forum if unresolved',
          },
          {
            'title': 'Refund Rights',
            'content':
            'You have the right to refund for defective products or poor services.\n\nWhen You Can Claim Refund:\n• Product is defective\n• Service not as promised\n• Wrong product delivered\n• Product damaged in transit\n\nReturn Policy:\n• Many sellers offer 7-30 day returns\n• Check terms before purchase\n• Online purchases often have better returns\n• Keep packaging and tags intact\n\nConsumer Forum:\n• File within 2 years of purchase\n• District forum for claims up to ₹1 crore\n• Simple process, minimal fees\n• National Consumer Helpline: 1800-11-4000',
          },
        ],
      },
    ];
  }

  static List<Map<String, dynamic>> getLegalForms() {
    return [
      {
        'title': 'Police Complaint (FIR)',
        'icon': Icons.local_police,
        'color': AppColors.error,
        'description': 'File a First Information Report',
        'fieldsCount': 8,
        'estimatedTime': 15,
      },
      {
        'title': 'Legal Aid Application',
        'icon': Icons.gavel,
        'color': AppColors.categoryBlue,
        'description': 'Apply for free legal assistance',
        'fieldsCount': 6,
        'estimatedTime': 10,
      },
      {
        'title': 'Consumer Complaint',
        'icon': Icons.shopping_bag,
        'color': AppColors.categoryOrange,
        'description': 'Report product or service issues',
        'fieldsCount': 7,
        'estimatedTime': 12,
      },
    ];
  }

  static List<Map<String, dynamic>> getLegalResources() {
    return [
      {
        'name': 'National Legal Services Authority',
        'type': 'Legal Aid Organization',
        'phone': '1800-11-4001',
        'address': 'Sector 12, Dwarka, New Delhi - 110078',
        'distance': 2.5,
      },
      {
        'name': 'District Legal Services Authority',
        'type': 'Government Office',
        'phone': '011-2345-6789',
        'address': 'Court Complex, District Courts, Delhi',
        'distance': 5.2,
      },
      {
        'name': 'Women Legal Aid Center',
        'type': 'NGO - Women Support',
        'phone': '1800-22-5757',
        'address': 'Karol Bagh, New Delhi - 110005',
        'distance': 3.8,
      },
      {
        'name': 'Labor Commissioner Office',
        'type': 'Government Office',
        'phone': '011-2389-4567',
        'address': 'Shram Shakti Bhawan, Rafi Marg, New Delhi',
        'distance': 4.5,
      },
      {
        'name': 'Consumer Forum Delhi',
        'type': 'Consumer Protection',
        'phone': '1800-11-4000',
        'address': 'Vinay Marg, Chanakyapuri, New Delhi',
        'distance': 6.1,
      },
    ];
  }
}