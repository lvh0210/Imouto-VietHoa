using System;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Reflection;
using System.Runtime.CompilerServices;

namespace ImoutoVi
{
    public static class TranslationHook
    {
        private static Dictionary<string, string> dict;
        private static bool initialized = false;
        private static HashSet<string> loggedMisses = new HashSet<string>();
        private static string logPath;
        private static bool cheatsEnsured = false;

        private static Regex moneyRegex;
        private static Regex dayTimeRegex;
        private static Regex jpDayRegex;
        private static Regex jpDateRegex;
        private static Regex simpleDayRegex;
        private static Regex countRegex;
        private static Regex volumeRegex;
        private static Regex dateRegex;
        private static Regex ordinalRegex;
        private static Regex conditionRegex;
        private static Regex tagWrapperRegex;
        private static Regex countdownRegex;
        private static Regex saveSlotRegex;
        private static Regex vnRegex;
        private static Regex ellipsisPrefixRegex;
        private static Regex sleepSaveRegex;
        private static Regex staminaUseRegex;
        private static Regex knowledgeIncRegex;

        private static Dictionary<string, string> timeMap;
        private static Dictionary<string, string> jpTimeMap;
        private static Dictionary<string, string> monthMap;
        private static Dictionary<string, string> statMap;
        private static Dictionary<string, string> topicMap;

        static TranslationHook()
        {
            moneyRegex = new Regex(@"^(?:Money:|所持金:)\s*([\d,]+)\s*(?:yen|円)$", RegexOptions.IgnoreCase);
            dayTimeRegex = new Regex(@"^Day(\d+),\s*([A-Za-z ]+)");
            jpDayRegex = new Regex(@"^([０-９\d]+)日目／(朝|昼|夕|夜|深夜)$");
            jpDateRegex = new Regex(@"^(\d{4})年(\d{1,2})月(\d{1,2})日\s*(\d{1,2}:\d{2})$");
            simpleDayRegex = new Regex(@"^(\d+)日$");
            countRegex = new Regex(@"^(\d+)\s*回$");
            volumeRegex = new Regex(@"^([\d\.]+)\s*ml$", RegexOptions.IgnoreCase);
            dateRegex = new Regex(@"^([A-Za-z]+)\s+(\d+),\s*(\d{4}),\s*(\d+:\d+)$");
            ordinalRegex = new Regex(@"^(\d+)(st|nd|rd|th)$");
            conditionRegex = new Regex(@"^(.+?)\s+((?:<[^>]+>)?\d+(?:</[^>]+>)?)\s+or higher\.$", RegexOptions.IgnoreCase);
            tagWrapperRegex = new Regex(@"^((?:<[^>]+>)+)(.+?)((?:</[^>]+>)+)$");
            countdownRegex = new Regex(@"^((?:<color=[^>]+><size=\d+>)?(\d+)(?:</size></color>)?)\s*days\s*left$", RegexOptions.IgnoreCase);
            saveSlotRegex = new Regex(@"^(?:Data|データ)(\d+)$", RegexOptions.IgnoreCase);
            vnRegex = new Regex(@"[àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬÈÉẺẼẸÊỀẾỂỄỆÌÍỈĨỊÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢÙÚỦŨỤƯỪỨỬỮỰỲÝỶỸỴĐ]");
            ellipsisPrefixRegex = new Regex(@"^([…\.、, \t]+)(.+)$");
            sleepSaveRegex = new Regex(@"^睡眠貯金が([-\d]+)貯まった！↑$");
            staminaUseRegex = new Regex(@"^体力を(\d+)使った！↓$");
            knowledgeIncRegex = new Regex(@"^([A-Za-z ]+)\s+Knowledge\s+increased\s+by\s+(\d+)!$", RegexOptions.IgnoreCase);

            timeMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Morning", "Sáng sớm" },
                { "Noon", "Buổi trưa" },
                { "Afternoon", "Buổi chiều" },
                { "Dusk", "Hoàng hôn" },
                { "Night", "Buổi tối" },
                { "Late Night", "Đêm muộn" }
            };

            jpTimeMap = new Dictionary<string, string>(StringComparer.Ordinal)
            {
                { "朝", "Sáng sớm" },
                { "昼", "Buổi trưa" },
                { "夕", "Buổi chiều" },
                { "夜", "Buổi tối" },
                { "深夜", "Đêm muộn" }
            };

            monthMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "January", "tháng 1" },
                { "February", "tháng 2" },
                { "March", "tháng 3" },
                { "April", "tháng 4" },
                { "May", "tháng 5" },
                { "June", "tháng 6" },
                { "July", "tháng 7" },
                { "August", "tháng 8" },
                { "September", "tháng 9" },
                { "October", "tháng 10" },
                { "November", "tháng 11" },
                { "December", "tháng 12" }
            };

            statMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Affinity", "Độ thân mật" },
                { "\"Bottom\" knowledge", "Kiến thức \"Nằm dưới\"" },
                { "Favorability to", "Độ hảo cảm" },
                { "Favorability", "Độ hảo cảm" },
                { "Knowledge", "Kiến thức" }
            };

            topicMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "Sexual", "Tình dục" },
                { "Receptive", "Nằm dưới" },
                { "Active", "Làm chủ" },
                { "Top", "Làm chủ" },
                { "Bottom", "Nằm dưới" },
                { "Hospitality", "Phục vụ" },
                { "SpecialPlay", "Trò dâm loạn" },
                { "KinkyPlay", "Trò dâm loạn" }
            };
        }

        [MethodImpl(MethodImplOptions.NoInlining)]
        private static string SafeGetUnityDataPath()
        {
            try { return UnityEngine.Application.dataPath; } catch { return null; }
        }

        [MethodImpl(MethodImplOptions.NoInlining)]
        private static string SafeGetUnityStreamingAssetsPath()
        {
            try { return UnityEngine.Application.streamingAssetsPath; } catch { return null; }
        }

        [MethodImpl(MethodImplOptions.NoInlining)]
        private static void SafeLog(string msg)
        {
            try { UnityEngine.Debug.Log(msg); } catch { }
        }

        [MethodImpl(MethodImplOptions.NoInlining)]
        private static void SafeLogWarning(string msg)
        {
            try { UnityEngine.Debug.LogWarning(msg); } catch { }
        }

        public static string SanitizeFont(string text)
        {
            if (string.IsNullOrEmpty(text)) return text;
            if (text.IndexOf('ẫ') >= 0) text = text.Replace('ẫ', 'â');
            if (text.IndexOf('Ẫ') >= 0) text = text.Replace('Ẫ', 'Â');
            if (text.IndexOf('Ư') >= 0) text = text.Replace('Ư', 'U');
            if (text.IndexOf("Ứm") >= 0) text = text.Replace("Ứm", "Um");
            if (text.IndexOf("Ứ\"m") >= 0) text = text.Replace("Ứ\"m", "Um");
            return text;
        }

        public static void Init()
        {
            if (initialized) return;
            initialized = true;
            dict = new Dictionary<string, string>(StringComparer.Ordinal);

            try
            {
                string basePath = null;
            try { basePath = SafeGetUnityDataPath(); } catch { }
            if (string.IsNullOrEmpty(basePath))
            {
                basePath = AppDomain.CurrentDomain.BaseDirectory;
            }
            basePath = (basePath ?? "").TrimEnd('\\', '/');

            logPath = Path.Combine(Path.Combine(basePath, ".."), "untranslated.log");
            if (!Directory.Exists(basePath))
            {
                logPath = "/storage/emulated/0/MT2/妹と過ごす1ヵ月間_Re/untranslated.log";
            }

            List<string> candidatePaths = new List<string>();

            string sAssets = null;
            try { sAssets = SafeGetUnityStreamingAssetsPath(); } catch { }
            if (!string.IsNullOrEmpty(sAssets))
            {
                candidatePaths.Add(Path.Combine(sAssets, "translation_extra.json"));
            }

                if (!string.IsNullOrEmpty(basePath))
                {
                    candidatePaths.Add(Path.Combine(basePath, "translation_extra.json"));
                    candidatePaths.Add(Path.Combine(basePath, "StreamingAssets", "translation_extra.json"));
                    try
                    {
                        var parent = Directory.GetParent(basePath);
                        if (parent != null)
                        {
                            candidatePaths.Add(Path.Combine(parent.FullName, "translation_extra.json"));
                            candidatePaths.Add(Path.Combine(parent.FullName, "StreamingAssets", "translation_extra.json"));
                        }
                    }
                    catch { }
                }

                try
                {
                    string cur = Directory.GetCurrentDirectory();
                    candidatePaths.Add(Path.Combine(cur, "translation_extra.json"));
                    candidatePaths.Add(Path.Combine(cur, "StreamingAssets", "translation_extra.json"));
                }
                catch { }

                candidatePaths.Add("/storage/emulated/0/MT2/妹と過ごす1ヵ月間_Re/妹と過ごす1ヵ月間_Re_Data/StreamingAssets/translation_extra.json");
                candidatePaths.Add("/storage/emulated/0/MT2/妹と過ごす1ヵ月間_Re/妹と過ごす1ヵ月間_Re_Data/translation_extra.json");

                string foundPath = null;
                foreach (var p in candidatePaths)
                {
                    if (!string.IsNullOrEmpty(p) && File.Exists(p))
                    {
                        foundPath = p;
                        break;
                    }
                }

                if (foundPath != null)
                {
                    string json = File.ReadAllText(foundPath, Encoding.UTF8);
                    ParseJson(json);
                    SafeLog("[ImoutoVi] Successfully loaded " + dict.Count + " entries from " + foundPath);
                }
                else
                {
                    SafeLogWarning("[ImoutoVi] translation_extra.json not found!");
                }
            }
            catch (Exception ex)
            {
                SafeLogWarning("[ImoutoVi] Init error: " + ex.Message);
            }
        }

        public static void AddVariations(string key, string val)
        {
            if (string.IsNullOrEmpty(key)) return;
            val = SanitizeFont(val);
            dict[key] = val;

            dict[key.Replace("\r\n", "\n").Trim()] = val;
            dict[key.Replace("\n", "\\n")] = val;
            dict[key.Replace("\n", "\r\n")] = val;

            if (key.Contains("~") || key.Contains("～"))
            {
                dict[key.Replace('~', '～')] = val;
                dict[key.Replace('～', '~')] = val;
            }

            if (key.Contains("　"))
            {
                dict[key.Replace("　", " ")] = val;
                dict[key.Replace("　", "")] = val;
            }
        }

        public static void ParseJson(string json)
        {
            Regex regex = new Regex("\"((?:\\\\\"|[^\"])*)\"\\s*:\\s*\"((?:\\\\\"|[^\"])*)\"");
            foreach (Match match in regex.Matches(json))
            {
                string key = Regex.Unescape(match.Groups[1].Value);
                string val = Regex.Unescape(match.Groups[2].Value);
                AddVariations(key, val);
            }
        }

        public static void EnsureCheats()
        {
            if (cheatsEnsured) return;
            cheatsEnsured = true;
            try
            {
                Type pdType = Type.GetType("PlayerData, Assembly-CSharp");
                if (pdType != null)
                {
                    MethodInfo m = pdType.GetMethod("ApplyMaxCheats", BindingFlags.Public | BindingFlags.Static);
                    if (m != null)
                    {
                        m.Invoke(null, null);
                        SafeLog("[ImoutoVi] ApplyMaxCheats executed via EnsureCheats!");
                    }
                }
            }
            catch (Exception ex)
            {
                SafeLogWarning("[ImoutoVi] EnsureCheats error: " + ex.Message);
            }
        }

        public static string Translate(string text)
        {
            if (string.IsNullOrEmpty(text)) return text;
            if (!initialized) Init();
            EnsureCheats();

            string res;
            if (dict != null && dict.Count > 0)
            {
                if (dict.TryGetValue(text, out res)) return SanitizeFont(res);

                string norm = text.Replace("\r\n", "\n").Replace("\\n", "\n").Trim();
                if (dict.TryGetValue(norm, out res)) return SanitizeFont(res);

                if (text.Contains("~") || text.Contains("～"))
                {
                    if (dict.TryGetValue(text.Replace('~', '～'), out res)) return SanitizeFont(res);
                    if (dict.TryGetValue(text.Replace('～', '~'), out res)) return SanitizeFont(res);
                }

                if (text.Contains("　"))
                {
                    if (dict.TryGetValue(text.Replace("　", " "), out res)) return SanitizeFont(res);
                    if (dict.TryGetValue(text.Replace("　", ""), out res)) return SanitizeFont(res);
                }

                // Tag wrapper check: <tag>text</tag>
                Match tagMatch = tagWrapperRegex.Match(text);
                if (tagMatch.Success)
                {
                    string inner = Translate(tagMatch.Groups[2].Value);
                    if (inner != tagMatch.Groups[2].Value)
                    {
                        return SanitizeFont(tagMatch.Groups[1].Value + inner + tagMatch.Groups[3].Value);
                    }
                }

                // Multi-line check
                if (text.Contains("\n"))
                {
                    string[] lines = text.Split('\n');
                    bool anyTrans = false;
                    for (int i = 0; i < lines.Length; i++)
                    {
                        string rawLine = lines[i];
                        string lineToTrans = rawLine.EndsWith("\r") ? rawLine.Substring(0, rawLine.Length - 1) : rawLine;
                        string trans = Translate(lineToTrans);
                        if (trans != lineToTrans)
                        {
                            anyTrans = true;
                            lines[i] = rawLine.EndsWith("\r") ? trans + "\r" : trans;
                        }
                    }
                    if (anyTrans)
                    {
                        return SanitizeFont(string.Join("\n", lines));
                    }
                }

                // Ellipsis prefix
                Match ellMatch = ellipsisPrefixRegex.Match(text);
                if (ellMatch.Success)
                {
                    string inner = Translate(ellMatch.Groups[2].Value);
                    if (inner != ellMatch.Groups[2].Value)
                    {
                        return SanitizeFont(ellMatch.Groups[1].Value + inner);
                    }
                }
            }

            // Dynamic Regex patterns
            Match m;

            // Sleep save
            m = sleepSaveRegex.Match(text);
            if (m.Success)
            {
                return SanitizeFont("Đã tích lũy " + m.Groups[1].Value + " Tiết kiệm giấc ngủ!↑");
            }

            // Stamina use
            m = staminaUseRegex.Match(text);
            if (m.Success)
            {
                return SanitizeFont("Đã tiêu hao " + m.Groups[1].Value + " Thể lực!↓");
            }

            // Knowledge inc
            m = knowledgeIncRegex.Match(text);
            if (m.Success)
            {
                string topicKey = m.Groups[1].Value.Trim();
                string topicVal;
                if (!topicMap.TryGetValue(topicKey, out topicVal)) topicVal = topicKey;
                return SanitizeFont("Kiến thức " + topicVal + " tăng thêm " + m.Groups[2].Value + "!");
            }

            // Countdown
            m = countdownRegex.Match(text);
            if (m.Success)
            {
                return SanitizeFont("Còn " + m.Groups[1].Value + " ngày");
            }

            // Money
            m = moneyRegex.Match(text);
            if (m.Success)
            {
                return SanitizeFont("Tiền: " + m.Groups[1].Value + " Yên");
            }

            // Day Time
            m = dayTimeRegex.Match(text);
            if (m.Success)
            {
                string day = m.Groups[1].Value;
                string tKey = m.Groups[2].Value.Trim();
                string tVal;
                if (timeMap.TryGetValue(tKey, out tVal))
                {
                    return SanitizeFont("Ngày " + day + ", " + tVal);
                }
                return SanitizeFont("Ngày " + day + ", " + tKey);
            }

            // Japanese Day Time
            m = jpDayRegex.Match(text);
            if (m.Success)
            {
                string day = m.Groups[1].Value
                    .Replace('０', '0').Replace('１', '1').Replace('２', '2')
                    .Replace('３', '3').Replace('４', '4').Replace('５', '5')
                    .Replace('６', '6').Replace('７', '7').Replace('８', '8').Replace('９', '9');
                string tKey = m.Groups[2].Value;
                string tVal;
                if (jpTimeMap.TryGetValue(tKey, out tVal))
                {
                    return SanitizeFont("Ngày " + day + " / " + tVal);
                }
                return SanitizeFont("Ngày " + day + " / " + tKey);
            }

            // Japanese Date: 2026年11月05日 18:27
            m = jpDateRegex.Match(text);
            if (m.Success)
            {
                string y = m.Groups[1].Value;
                string mo = m.Groups[2].Value;
                string d = m.Groups[3].Value;
                string time = m.Groups[4].Value;
                return SanitizeFont("Ngày " + d + " tháng " + mo + ", " + y + " " + time);
            }

            // English Date
            m = dateRegex.Match(text);
            if (m.Success)
            {
                string moKey = m.Groups[1].Value;
                string d = m.Groups[2].Value;
                string y = m.Groups[3].Value;
                string time = m.Groups[4].Value;
                string moVal;
                if (monthMap.TryGetValue(moKey, out moVal))
                {
                    return SanitizeFont("Ngày " + d + " " + moVal + ", " + y + " " + time);
                }
                return SanitizeFont("Ngày " + d + " " + moKey + ", " + y + " " + time);
            }

            // Ordinal: 1st, 2nd, 3rd, 26th
            m = ordinalRegex.Match(text);
            if (m.Success)
            {
                return SanitizeFont("Ngày " + m.Groups[1].Value);
            }

            // Simple Japanese day: 1日 -> Ngày 1
            m = simpleDayRegex.Match(text);
            if (m.Success)
            {
                return SanitizeFont("Ngày " + m.Groups[1].Value);
            }

            // Count: 0 回 -> 0 lần
            m = countRegex.Match(text);
            if (m.Success)
            {
                return SanitizeFont(m.Groups[1].Value + " lần");
            }

            // Volume: 0.0 ml -> 0.0 ml
            m = volumeRegex.Match(text);
            if (m.Success)
            {
                return SanitizeFont(m.Groups[1].Value + " ml");
            }

            // Save slots: Data1, データ1
            m = saveSlotRegex.Match(text);
            if (m.Success)
            {
                return SanitizeFont("Dữ liệu " + m.Groups[1].Value);
            }

            // Conditions
            m = conditionRegex.Match(text);
            if (m.Success)
            {
                string statKey = m.Groups[1].Value.Trim();
                string numVal = m.Groups[2].Value;
                string statVal;
                if (statMap.TryGetValue(statKey, out statVal))
                {
                    return SanitizeFont(statVal + " " + numVal + " trở lên.");
                }
                return SanitizeFont(statKey + " " + numVal + " trở lên.");
            }

            LogMiss(text);
            return SanitizeFont(text);
        }

        public static bool IsVietnamese(string text)
        {
            if (string.IsNullOrEmpty(text)) return false;
            return vnRegex.IsMatch(text);
        }

        public static void LogMiss(string text)
        {
            if (string.IsNullOrEmpty(text) || text.Length <= 1) return;
            if (IsVietnamese(text)) return;

            bool hasLetter = false;
            for (int i = 0; i < text.Length; i++)
            {
                if (char.IsLetter(text[i]))
                {
                    hasLetter = true;
                    break;
                }
            }
            if (!hasLetter) return;

            if (loggedMisses.Add(text))
            {
                if (!string.IsNullOrEmpty(logPath))
                {
                    try
                    {
                        File.AppendAllText(logPath, text + "\n", Encoding.UTF8);
                    }
                    catch { }
                }
            }
        }
    }
}
