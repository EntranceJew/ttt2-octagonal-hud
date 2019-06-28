local base = "dynamic_octagonal_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local shadowColorDark = Color(0, 0, 0, 200)
	local shadowColorWhite = Color(200, 200, 200, 200)

	function HUDELEMENT:DrawBg(x, y, w, h, c)
		DrawHUDElementBg(x, y, w, h, c)
	end

	function HUDELEMENT:DrawLines(x, y, w, h, a)
		a = a or 255

		DrawHUDElementLines(x, y, w, h, a)
	end

	-- x, y, width, height, color, progress, scale, text, textpadding
	function HUDELEMENT:DrawBar(x, y, w, h, c, p, s, t, tp)
        s = s or 1
        tp = tp or 14
		local w2 = math.Round(w * (p or 1))

		surface.SetDrawColor(clr(c))
		surface.DrawRect(x, y, w2, h)

		-- draw text
		if t then
			self:AdvancedText(t, "OctagonalBar", x + tp, y + 0.5*h, self:GetDefaultFontColor(c), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, s)
		end
	end

	function HUDELEMENT:GetDefaultFontColor(bgcolor)
		local color = 0
		if bgcolor.r + bgcolor.g + bgcolor.b < 500 then
			return COLOR_WHITE
		else
			return COLOR_BLACK
		end
	end

	function HUDELEMENT:ShadowedText(text, font, x, y, color, xalign, yalign, dark)
		local tmpCol = color.r + color.g + color.b > 200 and Color(shadowColorDark.r, shadowColorDark.g, shadowColorDark.b, color.a) or Color(shadowColorWhite.r, shadowColorWhite.g, shadowColorWhite.b, color.a)

		draw.SimpleText(text, font, x + 2, y + 2, tmpCol, xalign, yalign)
		draw.SimpleText(text, font, x + 1, y + 1, tmpCol, xalign, yalign)
		draw.SimpleText(text, font, x, y, color, xalign, yalign)
	end

	function HUDELEMENT:AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
		local mat
		if isvector(scale) or scale ~= 1.0 then
			mat = Matrix()
			mat:Translate(Vector(x, y))
			mat:Scale(isvector(scale) and scale or Vector(scale, scale, scale))
			mat:Translate(-Vector(ScrW() * 0.5, ScrH() * 0.5))

			render.PushFilterMag(TEXFILTER.ANISOTROPIC)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)

			cam.PushModelMatrix(mat)

			x = ScrW() * 0.5
			y = ScrH() * 0.5
		end

		if shadow then
			self:ShadowedText(text, font, x, y, color, xalign, yalign)
		else
			draw.SimpleText(text, font, x, y, color, xalign, yalign)
		end

		if isvector(scale) or scale ~= 1.0 then
			cam.PopModelMatrix(mat)

			render.PopFilterMag()
			render.PopFilterMin()
		end
	end

	HUDELEMENT.roundstate_string = {
		[ROUND_WAIT] = "round_wait",
		[ROUND_PREP] = "round_prep",
		[ROUND_ACTIVE] = "round_active",
		[ROUND_POST] = "round_post"
	}
end