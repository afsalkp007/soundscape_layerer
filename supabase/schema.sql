-- ==============================================================================
-- SoundScape Layerer: Supabase PostgreSQL Schema & Security Policies
-- ==============================================================================

-- 1. Create Sound Presets Table
CREATE TABLE IF NOT EXISTS public.sound_presets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon_code_point INTEGER NOT NULL,
    color_hex INTEGER NOT NULL,
    master_volume FLOAT NOT NULL DEFAULT 0.85,
    track_volumes JSONB NOT NULL DEFAULT '{}'::jsonb,
    track_pans JSONB NOT NULL DEFAULT '{}'::jsonb,
    track_enabled JSONB NOT NULL DEFAULT '{}'::jsonb,
    track_positions JSONB NOT NULL DEFAULT '{}'::jsonb,
    binaural_wave JSONB NOT NULL DEFAULT '{}'::jsonb,
    is_public BOOLEAN DEFAULT false,
    likes_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Indexes for fast community queries and user lookups
CREATE INDEX IF NOT EXISTS idx_sound_presets_user ON public.sound_presets(user_id);
CREATE INDEX IF NOT EXISTS idx_sound_presets_public ON public.sound_presets(is_public) WHERE is_public = true;
CREATE INDEX IF NOT EXISTS idx_sound_presets_likes ON public.sound_presets(likes_count DESC) WHERE is_public = true;

-- 3. Enable Row-Level Security (RLS)
ALTER TABLE public.sound_presets ENABLE ROW LEVEL SECURITY;

-- 4. Policies:
-- Anyone (authenticated or anonymous) can view public community soundscapes
CREATE POLICY "Public presets are readable by all"
    ON public.sound_presets
    FOR SELECT
    USING (is_public = true OR auth.uid() = user_id);

-- Authenticated users can insert their own presets
CREATE POLICY "Users can create their own presets"
    ON public.sound_presets
    FOR INSERT
    WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

-- Users can update their own presets
CREATE POLICY "Users can update their own presets"
    ON public.sound_presets
    FOR UPDATE
    USING (auth.uid() = user_id);

-- Users can delete their own presets
CREATE POLICY "Users can delete their own presets"
    ON public.sound_presets
    FOR DELETE
    USING (auth.uid() = user_id);

-- 5. Helper Function: Increment Like Count
CREATE OR REPLACE FUNCTION public.increment_preset_like(preset_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE public.sound_presets
    SET likes_count = likes_count + 1
    WHERE id = preset_id;
END;
$$;
