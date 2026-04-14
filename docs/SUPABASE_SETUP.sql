/// Production SQLsettings for Lex Bharat Supabase Database
/// Run these scripts in your Supabase SQL Editor to create tables

-- Form responses table
CREATE TABLE IF NOT EXISTS form_responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  form_type TEXT NOT NULL CHECK (form_type IN ('fir', 'legal_aid', 'rti', 'consumer', 'labor')),
  form_data JSONB NOT NULL,
  attachment_urls TEXT[] DEFAULT '{}',
  status TEXT NOT NULL DEFAULT 'submitted' CHECK (status IN ('submitted', 'under_review', 'approved', 'rejected')),
  admin_notes TEXT,
  case_number TEXT,
  submitted_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT valid_form_data CHECK (form_data != 'null'::jsonb)
);

CREATE INDEX idx_form_responses_user_id ON form_responses(user_id);
CREATE INDEX idx_form_responses_status ON form_responses(status);
CREATE INDEX idx_form_responses_form_type ON form_responses(form_type);

-- Form drafts table
CREATE TABLE IF NOT EXISTS form_drafts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  form_type TEXT NOT NULL CHECK (form_type IN ('fir', 'legal_aid', 'rti', 'consumer', 'labor')),
  form_data JSONB NOT NULL,
  saved_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(user_id, form_type)
);

CREATE INDEX idx_form_drafts_user_id ON form_drafts(user_id);

-- Case tracking cache
CREATE TABLE IF NOT EXISTS case_cache (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cnr_number TEXT UNIQUE NOT NULL,
  case_number TEXT,
  case_type TEXT,
  case_category_name TEXT,
  filing_date TEXT,
  fir_number TEXT,
  fir_year TEXT,
  respondent TEXT,
  petitioner TEXT,
  court_name TEXT,
  court_type TEXT,
  district_name TEXT,
  state_code TEXT,
  current_status TEXT DEFAULT 'Pending',
  case_status TEXT,
  next_hearing_date TIMESTAMP,
  judge_assigned TEXT,
  last_amendment_date TEXT,
  hearings_count INT DEFAULT 0,
  last_updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  cached_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_case_cache_cnr ON case_cache(cnr_number);
CREATE INDEX idx_case_cache_district ON case_cache(district_name);

-- User case tracking
CREATE TABLE IF NOT EXISTS user_case_tracking (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  cnr_number TEXT NOT NULL,
  added_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(user_id, cnr_number)
);

CREATE INDEX idx_user_case_tracking_user_id ON user_case_tracking(user_id);

-- Case reminders
CREATE TABLE IF NOT EXISTS case_reminders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  cnr_number TEXT NOT NULL,
  reminder_date TIMESTAMP WITH TIME ZONE NOT NULL,
  is_notified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_case_reminders_user_id ON case_reminders(user_id);
CREATE INDEX idx_case_reminders_date ON case_reminders(reminder_date);

-- Legal aid resources (organizations, helplines, etc.)
CREATE TABLE IF NOT EXISTS legal_resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  type TEXT CHECK (type IN ('ngo', 'helpline', 'legal_aid_center', 'bar_association', 'government')),
  description TEXT,
  phone TEXT,
  email TEXT,
  website TEXT,
  address TEXT,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  pincode TEXT,
  latitude FLOAT,
  longitude FLOAT,
  services TEXT[] DEFAULT '{}',
  availability_hours TEXT,
  language_support TEXT[] DEFAULT '{English}',
  is_verified BOOLEAN DEFAULT FALSE,
  rating FLOAT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_legal_resources_city ON legal_resources(city);
CREATE INDEX idx_legal_resources_state ON legal_resources(state);
CREATE INDEX idx_legal_resources_type ON legal_resources(type);
CREATE INDEX idx_legal_resources_location ON legal_resources(latitude, longitude);

-- Emergency contacts
CREATE TABLE IF NOT EXISTS emergency_contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('police', 'women', 'children', 'senior_citizen', 'ngo', 'government')),
  state TEXT,
  description TEXT,
  availability_24x7 BOOLEAN DEFAULT TRUE,
  language_support TEXT[] DEFAULT '{English, Hindi}',
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(phone, category, state)
);

CREATE INDEX idx_emergency_contacts_category ON emergency_contacts(category);
CREATE INDEX idx_emergency_contacts_state ON emergency_contacts(state);

-- User chat history (extended)
CREATE TABLE IF NOT EXISTS chat_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  tokens_used INT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  metadata JSONB
);

CREATE INDEX idx_chat_history_user_id ON chat_history(user_id);
CREATE INDEX idx_chat_history_created_at ON chat_history(created_at);

-- User learning progress
CREATE TABLE IF NOT EXISTS learning_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content_id TEXT NOT NULL,
  status TEXT DEFAULT 'started' CHECK (status IN ('started', 'in_progress', 'completed')),
  progress_percent INT DEFAULT 0,
    quiz_score INT,
  started_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  completed_at TIMESTAMP
);

CREATE INDEX idx_learning_progress_user_id ON learning_progress(user_id);
CREATE INDEX idx_learning_progress_content_id ON learning_progress(content_id);

-- Enable Row Level Security
ALTER TABLE form_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_drafts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_case_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_progress ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can only see their own form responses"
  ON form_responses FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own form responses"
  ON form_responses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can only see their own form drafts"
  ON form_drafts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert/update their own form drafts"
  ON form_drafts FOR INSERT, UPDATE
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can only see their own case tracking"
  ON user_case_tracking FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own case tracking"
  ON user_case_tracking FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can see their own chat history"
  ON chat_history FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own messages"
  ON chat_history FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can only see their own learning progress"
  ON learning_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert/update their own learning progress"
  ON learning_progress FOR INSERT, UPDATE
  WITH CHECK (auth.uid() = user_id);

-- Everyone can read legal resources and emergency contacts (no sensitive data)
CREATE POLICY "Public read access to legal resources"
  ON legal_resources FOR SELECT
  USING (TRUE);

CREATE POLICY "Public read access to emergency contacts"
  ON emergency_contacts FOR SELECT
  USING (TRUE);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_form_responses_updated_at BEFORE UPDATE
  ON form_responses FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_form_drafts_updated_at BEFORE UPDATE
  ON form_drafts FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_legal_resources_updated_at BEFORE UPDATE
  ON legal_resources FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
