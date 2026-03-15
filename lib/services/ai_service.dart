class AIService {
  Future<String> getLegalAdvice(String question) async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 2));

    return _getMockResponse(question);
  }

  String _getMockResponse(String question) {
    final lowerQ = question.toLowerCase();

    if (lowerQ.contains('minimum wage') || lowerQ.contains('salary')) {
      return 'Minimum wage in India varies by state. As per the Code on Wages 2019, every state sets its own minimum wage. You have the right to receive at least the minimum wage prescribed for your state and industry. For example, Delhi\'s minimum wage for unskilled workers is ₹17,234 per month. Contact your state labor department for exact figures.';
    } else if (lowerQ.contains('fir') || lowerQ.contains('police')) {
      return 'You can file an FIR (First Information Report) at any police station in India, regardless of jurisdiction, under Section 154 of CrPC. Police cannot refuse to register an FIR for cognizable offenses. If they refuse:\n\n1. Approach the Superintendent of Police\n2. File online through your state police website\n3. Send written complaint via registered post\n4. Approach the magistrate\n\nKeep a copy of your complaint for reference.';
    } else if (lowerQ.contains('consumer') || lowerQ.contains('product')) {
      return 'Under the Consumer Protection Act 2019, you have the right to:\n\n1. Seek compensation for defective products/services\n2. File complaint within 2 years\n3. Approach District Consumer Forum (claims up to ₹1 crore)\n\nYou can also contact National Consumer Helpline: 1800-11-4000 or file online at consumerhelpline.gov.in';
    } else if (lowerQ.contains('rent') || lowerQ.contains('landlord') || lowerQ.contains('eviction')) {
      return 'Landlord-tenant relations are governed by state rent control acts:\n\n1. Landlord must give proper notice (15 days to 1 month)\n2. Cannot evict without valid reason\n3. Illegal eviction is a criminal offense\n4. Keep all rent receipts as proof\n5. Written rent agreement is essential\n\nIf facing illegal eviction, file police complaint or approach civil court.';
    } else if (lowerQ.contains('harassment') || lowerQ.contains('workplace')) {
      return 'Workplace harassment is illegal. Your rights:\n\n1. File complaint with Internal Complaints Committee (ICC)\n2. Every organization with 10+ employees must have ICC\n3. Complaint must be filed within 3 months\n4. Protection against retaliation\n\nFor sexual harassment: Women Helpline 1091\nFor labor issues: Contact labor commissioner';
    } else if (lowerQ.contains('dowry')) {
      return 'Dowry is illegal under Dowry Prohibition Act 1961:\n\n1. Giving or taking dowry is punishable\n2. Imprisonment up to 5 years + fine ₹15,000+\n3. Dowry harassment is punishable under Section 498A IPC\n\nIf facing dowry harassment:\n1. File FIR at police station\n2. Contact Women Helpline: 1091\n3. Approach Women\'s Commission\n4. Seek legal aid';
    } else if (lowerQ.contains('domestic violence')) {
      return 'Protection of Women from Domestic Violence Act 2005 provides:\n\n1. Right to reside in shared household\n2. Monetary relief\n3. Custody of children\n4. Protection orders\n\nImmediate steps:\n1. Call Women Helpline: 1091\n2. File complaint with Protection Officer\n3. Approach magistrate for protection order\n4. Seek shelter home if needed\n\nYou are not alone. Help is available 24/7.';
    } else if (lowerQ.contains('loan') || lowerQ.contains('debt')) {
      return 'Your rights regarding loans:\n\n1. Right to fair collection practices\n2. Lenders cannot harass or threaten\n3. Cannot force to sell property without court order\n4. Banks must give notice before declaring NPA\n\nIf facing harassment:\n1. Complaint to Banking Ombudsman\n2. File police complaint for criminal intimidation\n3. Approach consumer court';
    } else if (lowerQ.contains('legal aid') || lowerQ.contains('free lawyer')) {
      return 'Free legal aid is available to:\n\n1. Women and children\n2. SC/ST/OBC members\n3. Persons with disabilities\n4. Income below ₹1 lakh/year\n5. Victims of trafficking\n\nContact:\n1. National Legal Services Authority: 1800-11-4001\n2. District Legal Services Authority\n3. Taluk Legal Services Committee\n\nServices include free lawyer, court fees exemption, and legal advice.';
    } else {
      return 'Thank you for your question. For detailed legal advice specific to your situation, I recommend:\n\n1. Consulting with a legal aid organization (free services available)\n2. Approaching District Legal Services Authority\n3. Calling National Legal Services Helpline: 1800-11-4001\n\nYou can also use the "Find Help" section in this app to locate legal aid centers near you. Remember, knowing your rights is the first step to justice!';
    }
  }
}